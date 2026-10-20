#pragma once

#include <QImage>
#include <QWidget>

class QLabel;
class QPushButton;

// In-activity GRAPHICS overlay (char cells). Child of MainWindow — not a
// second top-level QWindow (Android IME / EGL deadlock risk).
class GraphicsWindow : public QWidget {
    Q_OBJECT
public:
    explicit GraphicsWindow(QWidget *parent = nullptr);

    void openGrid(int cols, int rows);
    void setTitleText(const QString &title);
    void refreshCells();
    void closeGrid();

    void paintCanvas(QWidget *canvas);
    void forwardKey(QKeyEvent *event);
    void forwardMouse(QMouseEvent *event);

signals:
    void userClosed();

protected:
    void paintEvent(QPaintEvent *event) override;
    void keyPressEvent(QKeyEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    void noteMouse(const QPoint &pos, Qt::MouseButtons buttons);
    void layoutChrome();

    QWidget *m_chrome = nullptr;
    QLabel *m_title = nullptr;
    QPushButton *m_close = nullptr;
    QWidget *m_canvas = nullptr;

    int m_cols = 80;
    int m_rows = 25;
    int m_cellW = 10;
    int m_cellH = 18;
    QByteArray m_cells;
    QImage m_pix;
    int m_pixW = 0;
    int m_pixH = 0;
    bool m_hasPix = false;
};
