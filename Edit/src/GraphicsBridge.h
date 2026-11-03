#pragma once

#include <QObject>
#include <QString>

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
    // Keep this many pixels at the bottom of the host free for the keypad.
    void setBottomInset(int pixels);
    bool isOpen() const;
    void postKey(int key, const QString &text);

    // Invoked on the UI thread (from C hooks via QMetaObject).
    long long openOnUi(long long cols, long long rows);
    void closeOnUi();
    void refreshOnUi();
    void nameOnUi(const QByteArray &title);

private:
    void applyGeometry();

    QWidget *m_hostParent = nullptr;
    GraphicsWindow *m_window = nullptr;
    int m_bottomInset = 0;
};
