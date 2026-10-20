#include "ForthPipe.h"

#include <QCoreApplication>
#include <QMetaObject>
#include <QStandardPaths>
#include <QThread>

#include <atomic>
#include <cstring>
#include <string>
#include <thread>

#include "emit_buf.h"
#include "host_debug_android.h"
#include "host_file_android.h"
#include "host_view.h"
#include "kernel_api.h"

// In-process Forth for Android: same ForthPipe API MainWindow already uses,
// backed by libforthnative instead of a Windows named-pipe companion.
// Eval runs on a worker thread so debugger KEY can block without freezing UI.

namespace {

ForthPipe *g_pipe = nullptr;
std::atomic<bool> g_eval_running{false};

void android_flush_emit_to_ui(void)
{
    if (g_pipe == nullptr)
        return;
    const char *text = emit_buf_text();
    if (text == nullptr || text[0] == '\0')
        return;
    const QString out = QString::fromUtf8(text);
    emit_buf_reset();
    QMetaObject::invokeMethod(
        g_pipe,
        [out]() {
            if (g_pipe != nullptr)
                g_pipe->noteOutput(out);
        },
        Qt::QueuedConnection);
}

void android_paint_to_ui(int armed, int paused, int line, int off, int len, const char *name,
                         const char *path)
{
    if (g_pipe == nullptr)
        return;
    const QString n = QString::fromUtf8(name != nullptr ? name : "");
    const QString p = QString::fromUtf8(path != nullptr ? path : "");
    QMetaObject::invokeMethod(
        g_pipe,
        [armed, paused, line, off, len, n, p]() {
            if (g_pipe != nullptr)
                g_pipe->noteDebug(armed != 0, paused != 0, line, off, len, n, p);
        },
        Qt::QueuedConnection);
}

} // namespace

ForthPipe::ForthPipe(QObject *parent) : QObject(parent) { g_pipe = this; }

ForthPipe::~ForthPipe()
{
    shutdown();
    if (g_pipe == this)
        g_pipe = nullptr;
}

void ForthPipe::start()
{
    m_stop.store(false);
    g_pipe = this;
    kernel_set_emit(android_emit_char);
    emit_buf_set_flush(android_flush_emit_to_ui);
    kernel_set_key(android_debug_key);
    android_debug_set_hooks(android_flush_emit_to_ui, android_paint_to_ui);
    android_debug_clear_key();
    emit_buf_reset();
    // Match MainWindow's shipped-resources root (…/EditForthAnd) so INCLUDE /
    // OPEN-FILE / CHDIR see the same tree the editor opens from.
    const QByteArray forthRoot =
        (QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
         QStringLiteral("/EditForthAnd"))
            .toUtf8();
    android_host_set_roots(forthRoot.constData());
    const int rc = kernel_init();
    if (rc != 0) {
        emit engineFailed(QStringLiteral("kernel_init failed (%1)").arg(rc));
        return;
    }
    // Match Windows companion: sign-on (kernel boot + product banner) first,
    // then Autoload. forth_boot prints === … === before forth_autoload().
    QString boot = QString::fromUtf8(emit_buf_text());
    if (!boot.isEmpty() && !boot.endsWith(QLatin1Char('\n')))
        boot.append(QLatin1Char('\n'));
    const QString banner =
        QStringLiteral("=== %1 %2 === %3 ===\n"
                       "version=%2  built=%3  console=%1\n"
                       "kernel_init => %4\n")
            .arg(QLatin1String(kernel_console), QLatin1String(kernel_version),
                 QLatin1String(kernel_built))
            .arg(rc);
    emit directoryChanged(QString::fromUtf8(forthRoot));
    emit outputReceived(boot + banner);
    emit versionReceived(QStringLiteral("%1\n%2\n%3")
                             .arg(QLatin1String(kernel_version),
                                  QLatin1String(kernel_built),
                                  QLatin1String(kernel_console)));

    emit_buf_reset();
    android_host_autoload();
    QString autoText = QString::fromUtf8(emit_buf_text());
    if (!autoText.isEmpty()) {
        if (!autoText.endsWith(QLatin1Char('\n')))
            autoText.append(QLatin1Char('\n'));
        emit outputReceived(autoText);
    }
}

void ForthPipe::shutdown()
{
    m_stop.store(true);
    android_debug_request_quit();
    // Wait briefly for an in-flight eval to leave KEY.
    for (int i = 0; i < 50 && g_eval_running.load(); ++i)
        QThread::msleep(20);
}

void ForthPipe::sendKey(int key) { android_debug_post_key(key); }

void ForthPipe::sendArm() { android_debug_post_arm(); }

void ForthPipe::requestBreaks() {}

void ForthPipe::enableBreak(int index, bool on)
{
    Q_UNUSED(index);
    Q_UNUSED(on);
}

void ForthPipe::toggleBreak(const QString &name) { Q_UNUSED(name); }

void ForthPipe::requestLast()
{
    char name[64];
    if (!android_last_name(name, sizeof name))
        emit lastReceived(QString());
    else
        emit lastReceived(QString::fromUtf8(name));
}

void ForthPipe::requestView(const QString &name)
{
    char path[512];
    long long line = 0;
    const QByteArray token = name.toUtf8();
    if (android_view_word(token.constData(), path, sizeof path, &line) != 0) {
        // Match companion wording so the DebugBar error is actionable.
        emit statusError(QStringLiteral("undefined or no source stamp: %1").arg(name));
        return;
    }
    emit editReceived(QString::fromUtf8(path), static_cast<int>(line));
}

void ForthPipe::requestTree(const QString &mode) { Q_UNUSED(mode); }

void ForthPipe::requestRunTo(int utf8Offset) { Q_UNUSED(utf8Offset); }

bool ForthPipe::signalBreak() { return android_debug_signal_break() != 0; }

QString ForthPipe::forthPath() const
{
    return QCoreApplication::applicationFilePath();
}

void ForthPipe::eval(const QString &line)
{
    if (m_stop.load())
        return;
    if (g_eval_running.exchange(true)) {
        emit statusError(QStringLiteral("debugger paused - use Step, Continue, or Stop"));
        return;
    }
    const QByteArray utf8 = line.toUtf8();
    std::thread([this, utf8]() {
        emit_buf_reset();
        android_edit_clear();
        android_debug_clear_key();
        const int rc = kernel_eval(utf8.constData(), static_cast<size_t>(utf8.size()));
        QString out = QString::fromUtf8(emit_buf_text());
        emit_buf_reset();
        char path[512];
        long long editLine = 0;
        const bool haveEdit = android_edit_take(path, sizeof path, &editLine) != 0;
        const QString editPath = haveEdit ? QString::fromUtf8(path) : QString();
        const int editLn = haveEdit ? static_cast<int>(editLine) : 0;
        QMetaObject::invokeMethod(
            this,
            [this, out, rc, haveEdit, editPath, editLn]() {
                if (rc == -2 && out.isEmpty())
                    noteOutput(QStringLiteral("kernel not initialized\n"));
                else if (rc != 0 && rc != 1 && out.isEmpty())
                    noteOutput(QStringLiteral("eval failed (%1)\n").arg(rc));
                else if (!out.isEmpty())
                    noteOutput(out);
                if (haveEdit)
                    noteEdit(editPath, editLn);
                if (rc == 1)
                    noteStopped();
                // Disarm paint when eval ends without an active pause.
                // host_debug_paint already notified during the run; a final
                // idle paint keeps the DebugBar in sync after Stop/finish.
                g_eval_running.store(false);
            },
            Qt::QueuedConnection);
    }).detach();
}

void ForthPipe::noteOutput(const QString &text) { emit outputReceived(text); }

void ForthPipe::noteDirectory(const QString &path) { emit directoryChanged(path); }

void ForthPipe::noteStopped() { emit engineStopped(); }

void ForthPipe::noteFailed(const QString &message) { emit engineFailed(message); }

void ForthPipe::noteDebug(bool armed, bool paused, int line, int off, int len, const QString &name,
                          const QString &path)
{
    emit debugReceived(armed, paused, line, off, len, name, path);
}

void ForthPipe::noteBreaks(const QString &text) { emit breaksReceived(text); }

void ForthPipe::noteError(const QString &text) { emit statusError(text); }

void ForthPipe::noteEdit(const QString &path, int line) { emit editReceived(path, line); }

void ForthPipe::noteLast(const QString &name) { emit lastReceived(name); }

void ForthPipe::noteVersion(const QString &text) { emit versionReceived(text); }

void ForthPipe::post(const QByteArray &json) { Q_UNUSED(json); }
