#include "GraphicsBridge.h"

#include "GraphicsWindow.h"
#include "host_gfx_android.h"

#include <QMetaObject>
#include <QThread>

namespace {

GraphicsBridge *g_bridge = nullptr;
QByteArray g_pendingTitle;

long long gfx_ui_open(long long cols, long long rows)
{
    if (g_bridge == nullptr)
        return -1;
    long long ior = -1;
    auto run = [cols, rows, &ior]() { ior = g_bridge->openOnUi(cols, rows); };
    if (QThread::currentThread() == g_bridge->thread())
        run();
    else
        QMetaObject::invokeMethod(g_bridge, run, Qt::BlockingQueuedConnection);
    return ior;
}

void gfx_ui_close(void)
{
    if (g_bridge == nullptr)
        return;
    auto run = []() { g_bridge->closeOnUi(); };
    if (QThread::currentThread() == g_bridge->thread())
        run();
    else
        QMetaObject::invokeMethod(g_bridge, run, Qt::BlockingQueuedConnection);
}

void gfx_ui_refresh(void)
{
    if (g_bridge == nullptr)
        return;
    QMetaObject::invokeMethod(g_bridge, []() { g_bridge->refreshOnUi(); },
                              Qt::QueuedConnection);
}

void gfx_ui_name(const char *title, long long nbytes)
{
    QByteArray text;
    if (title != nullptr && nbytes > 0)
        text = QByteArray(title, int(nbytes));
    else
        text = QByteArrayLiteral("EditForthAnd GRAPHICS");
    g_pendingTitle = text;
    if (g_bridge == nullptr)
        return;
    QMetaObject::invokeMethod(
        g_bridge, [text]() { g_bridge->nameOnUi(text); }, Qt::QueuedConnection);
}

} // namespace

GraphicsBridge::GraphicsBridge(QWidget *hostParent, QObject *parent)
    : QObject(parent), m_hostParent(hostParent)
{
    g_bridge = this;
}

GraphicsBridge::~GraphicsBridge()
{
    android_gfx_set_hooks(nullptr, nullptr, nullptr, nullptr);
    if (g_bridge == this)
        g_bridge = nullptr;
    delete m_window;
    m_window = nullptr;
}

void GraphicsBridge::installHooks()
{
    android_gfx_set_hooks(gfx_ui_open, gfx_ui_close, gfx_ui_refresh, gfx_ui_name);
}

void GraphicsBridge::syncGeometry()
{
    if (m_window != nullptr && m_window->isVisible() && m_hostParent != nullptr)
        m_window->setGeometry(m_hostParent->rect());
}

long long GraphicsBridge::openOnUi(long long cols, long long rows)
{
    if (m_hostParent == nullptr)
        return -1;
    if (m_window == nullptr) {
        m_window = new GraphicsWindow(m_hostParent);
        connect(m_window, &GraphicsWindow::userClosed, this, [this] {
            if (m_window != nullptr)
                m_window->hide();
        });
    }
    if (m_hostParent != nullptr)
        m_window->setGeometry(m_hostParent->rect());
    if (!g_pendingTitle.isEmpty())
        m_window->setTitleText(QString::fromUtf8(g_pendingTitle));
    m_window->openGrid(int(cols), int(rows));
    m_window->refreshCells();
    return 0;
}

void GraphicsBridge::closeOnUi()
{
    if (m_window != nullptr)
        m_window->closeGrid();
}

void GraphicsBridge::refreshOnUi()
{
    if (m_window != nullptr && m_window->isVisible())
        m_window->refreshCells();
}

void GraphicsBridge::nameOnUi(const QByteArray &title)
{
    if (m_window == nullptr)
        return;
    m_window->setTitleText(QString::fromUtf8(title));
}
