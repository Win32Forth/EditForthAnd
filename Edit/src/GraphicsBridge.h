#pragma once

#include <QObject>

class GraphicsWindow;
class QWidget;

// Owns the GRAPHICS overlay and registers C hooks so host_app_* (Forth worker
// thread) can open/blit/name on the Qt UI thread.
class GraphicsBridge : public QObject {
    Q_OBJECT
public:
    explicit GraphicsBridge(QWidget *hostParent, QObject *parent = nullptr);
    ~GraphicsBridge() override;

    void installHooks();
    void syncGeometry();

    // Invoked on the UI thread (from C hooks via QMetaObject).
    long long openOnUi(long long cols, long long rows);
    void closeOnUi();
    void refreshOnUi();
    void nameOnUi(const QByteArray &title);

private:
    QWidget *m_hostParent = nullptr;
    GraphicsWindow *m_window = nullptr;
};
