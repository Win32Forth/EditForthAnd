#include "ForthPipe.h"

#include <QCoreApplication>
#include <QMetaObject>
#include <QStandardPaths>
#include <QThread>

#include <cstring>
#include <string>

#include "emit_buf.h"
#include "host_file_android.h"
#include "host_view.h"
#include "kernel_api.h"

// In-process Forth for Android: same ForthPipe API MainWindow already uses,
// backed by libforthnative instead of a Windows named-pipe companion.

ForthPipe::ForthPipe(QObject *parent) : QObject(parent) {}

ForthPipe::~ForthPipe() { shutdown(); }

void ForthPipe::start() {
    m_stop.store(false);
    kernel_set_emit(android_emit_char);
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

void ForthPipe::shutdown() {
    m_stop.store(true);
}

void ForthPipe::sendKey(int key) { Q_UNUSED(key); }

void ForthPipe::sendArm() {}

void ForthPipe::requestBreaks() {}

void ForthPipe::enableBreak(int index, bool on) {
    Q_UNUSED(index);
    Q_UNUSED(on);
}

void ForthPipe::toggleBreak(const QString &name) { Q_UNUSED(name); }

void ForthPipe::requestLast() {
    char name[64];
    if (!android_last_name(name, sizeof name))
        emit lastReceived(QString());
    else
        emit lastReceived(QString::fromUtf8(name));
}

void ForthPipe::requestView(const QString &name) {
    char path[512];
    long long line = 0;
    if (android_view_word(name.toUtf8().constData(), path, sizeof path, &line) != 0) {
        emit statusError(QStringLiteral("undefined or no source: %1").arg(name));
        return;
    }
    emit editReceived(QString::fromUtf8(path), static_cast<int>(line));
}

void ForthPipe::requestTree(const QString &mode) { Q_UNUSED(mode); }

void ForthPipe::requestRunTo(int utf8Offset) { Q_UNUSED(utf8Offset); }

bool ForthPipe::signalBreak() { return false; }

QString ForthPipe::forthPath() const {
    return QCoreApplication::applicationFilePath();
}

void ForthPipe::eval(const QString &line) {
    if (m_stop.load())
        return;
    const QByteArray utf8 = line.toUtf8();
    emit_buf_reset();
    android_edit_clear();
    const int rc = kernel_eval(utf8.constData(), static_cast<size_t>(utf8.size()));
    QString out = QString::fromUtf8(emit_buf_text());
    if (rc == -2 && out.isEmpty())
        out = QStringLiteral("kernel not initialized\n");
    else if (rc != 0 && rc != 1 && out.isEmpty())
        out = QStringLiteral("eval failed (%1)\n").arg(rc);
    // Always surface emit text, including before BYE, so INCLUDE errors are visible.
    if (!out.isEmpty())
        emit outputReceived(out);
    if (rc == 1) {
        emit engineStopped();
        return;
    }
    char path[512];
    long long editLine = 0;
    if (android_edit_take(path, sizeof path, &editLine))
        emit editReceived(QString::fromUtf8(path), static_cast<int>(editLine));
}

void ForthPipe::noteOutput(const QString &text) { emit outputReceived(text); }

void ForthPipe::noteDirectory(const QString &path) { emit directoryChanged(path); }

void ForthPipe::noteStopped() { emit engineStopped(); }

void ForthPipe::noteFailed(const QString &message) { emit engineFailed(message); }

void ForthPipe::noteDebug(bool armed, bool paused, int line, int off, int len, const QString &name,
                          const QString &path) {
    emit debugReceived(armed, paused, line, off, len, name, path);
}

void ForthPipe::noteBreaks(const QString &text) { emit breaksReceived(text); }

void ForthPipe::noteError(const QString &text) { emit statusError(text); }

void ForthPipe::noteEdit(const QString &path, int line) { emit editReceived(path, line); }

void ForthPipe::noteLast(const QString &name) { emit lastReceived(name); }

void ForthPipe::noteVersion(const QString &text) { emit versionReceived(text); }

void ForthPipe::post(const QByteArray &json) {
    Q_UNUSED(json);
}
