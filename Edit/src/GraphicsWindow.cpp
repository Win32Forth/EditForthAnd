#include "GraphicsWindow.h"

#include "host_gfx_android.h"

#include <QFont>
#include <QFontMetrics>
#include <QHBoxLayout>
#include <QKeyEvent>
#include <cstring>
#include <QLabel>
#include <QMouseEvent>
#include <QPainter>
#include <QPushButton>
#include <QResizeEvent>
#include <QVBoxLayout>

namespace {

class GfxCanvas final : public QWidget {
public:
    explicit GfxCanvas(GraphicsWindow *owner) : QWidget(owner), m_owner(owner)
    {
        setAttribute(Qt::WA_OpaquePaintEvent, true);
        setFocusPolicy(Qt::StrongFocus);
        setStyleSheet(QStringLiteral("background: #000000;"));
    }

protected:
    void paintEvent(QPaintEvent *) override { m_owner->paintCanvas(this); }
    void keyPressEvent(QKeyEvent *event) override { m_owner->forwardKey(event); }
    void mousePressEvent(QMouseEvent *event) override
    {
        m_owner->forwardMouse(event);
        setFocus(Qt::MouseFocusReason);
    }
    void mouseMoveEvent(QMouseEvent *event) override { m_owner->forwardMouse(event); }
    void mouseReleaseEvent(QMouseEvent *event) override { m_owner->forwardMouse(event); }

private:
    GraphicsWindow *m_owner = nullptr;
};

} // namespace

GraphicsWindow::GraphicsWindow(QWidget *parent) : QWidget(parent)
{
    setObjectName(QStringLiteral("GraphicsWindow"));
    setFocusPolicy(Qt::StrongFocus);
    setAttribute(Qt::WA_StyledBackground, true);
    setStyleSheet(QStringLiteral("GraphicsWindow { background: #1a1a1a; }"));
    setAccessibleName(QStringLiteral("EditForthAnd GRAPHICS"));

    auto *root = new QVBoxLayout(this);
    root->setContentsMargins(0, 0, 0, 0);
    root->setSpacing(0);

    m_chrome = new QWidget(this);
    m_chrome->setFixedHeight(44);
    m_chrome->setStyleSheet(QStringLiteral("background: #263238;"));
    auto *bar = new QHBoxLayout(m_chrome);
    bar->setContentsMargins(12, 4, 8, 4);
    m_title = new QLabel(QStringLiteral("EditForthAnd GRAPHICS"), m_chrome);
    m_title->setStyleSheet(QStringLiteral("color: #eceff1; font-weight: 600;"));
    m_title->setAccessibleName(QStringLiteral("EditForthAnd GRAPHICS"));
    m_close = new QPushButton(QStringLiteral("Close"), m_chrome);
    m_close->setAccessibleName(QStringLiteral("Close"));
    m_close->setFixedHeight(32);
    connect(m_close, &QPushButton::clicked, this, [this] {
        hide();
        android_gfx_note_closed();
        emit userClosed();
    });
    bar->addWidget(m_title, 1);
    bar->addWidget(m_close);

    m_canvas = new GfxCanvas(this);

    root->addWidget(m_chrome);
    root->addWidget(m_canvas, 1);
    hide();
}

void GraphicsWindow::layoutChrome()
{
    const qreal dpr = devicePixelRatioF() > 0 ? devicePixelRatioF() : 1.0;
    m_cellW = qMax(8, int(9 * dpr));
    m_cellH = qMax(14, int(18 * dpr));
    QFont font(QStringLiteral("monospace"));
    font.setStyleHint(QFont::Monospace);
    font.setFixedPitch(true);
    font.setPixelSize(qMax(12, m_cellH - 4));
    setFont(font);
    if (m_canvas != nullptr)
        m_canvas->setFont(font);
}

void GraphicsWindow::openGrid(int cols, int rows)
{
    layoutChrome();
    m_cols = qBound(1, cols, ANDROID_GFX_COLS_MAX);
    m_rows = qBound(1, rows, ANDROID_GFX_ROWS_MAX);
    m_cells = QByteArray(m_cols * m_rows, ' ');
    if (parentWidget() != nullptr)
        setGeometry(parentWidget()->rect());
    show();
    raise();
    activateWindow();
    m_canvas->setFocus(Qt::OtherFocusReason);
    setFocus(Qt::OtherFocusReason);
    refreshCells();
}

void GraphicsWindow::setTitleText(const QString &title)
{
    const QString t = title.isEmpty() ? QStringLiteral("EditForthAnd GRAPHICS") : title;
    m_title->setText(t);
    m_title->setAccessibleName(t);
    setAccessibleName(t);
}

void GraphicsWindow::refreshCells()
{
    QByteArray buf(ANDROID_GFX_CELL_MAX, '\0');
    int cols = 0;
    int rows = 0;
    const int n = android_gfx_copy_cells(reinterpret_cast<unsigned char *>(buf.data()),
                                         ANDROID_GFX_CELL_MAX, &cols, &rows);
    if (cols > 0)
        m_cols = cols;
    if (rows > 0)
        m_rows = rows;
    const int need = qMax(0, m_cols * m_rows);
    m_cells = buf.left(qMin(n, need));
    if (m_cells.size() < need)
        m_cells.append(QByteArray(need - m_cells.size(), ' '));

    int pw = 0;
    int ph = 0;
    int has = 0;
    android_gfx_copy_pixels(nullptr, 0, &pw, &ph, &has);
    m_hasPix = has != 0 && pw > 0 && ph > 0;
    m_pixW = pw;
    m_pixH = ph;
    if (m_hasPix) {
        const int need = pw * ph * 4;
        QByteArray pixBuf(need, Qt::Uninitialized);
        const int pn = android_gfx_copy_pixels(
            reinterpret_cast<unsigned char *>(pixBuf.data()), need, &pw, &ph, &has);
        if (pn < need) {
            m_hasPix = false;
            m_pix = QImage();
        } else {
            // Host expands to BGRA; Qt ARGB32 matches that byte order on LE.
            QImage img(pw, ph, QImage::Format_ARGB32);
            for (int y = 0; y < ph; ++y) {
                memcpy(img.scanLine(y), pixBuf.constData() + y * pw * 4,
                       size_t(pw) * 4u);
            }
            m_pix = img;
        }
    } else {
        m_pix = QImage();
    }

    if (m_canvas != nullptr)
        m_canvas->update();
}

void GraphicsWindow::closeGrid()
{
    hide();
}

void GraphicsWindow::paintCanvas(QWidget *canvas)
{
    QPainter p(canvas);
    p.fillRect(canvas->rect(), QColor(0, 0, 0));
    if (m_hasPix && !m_pix.isNull()) {
        p.setRenderHint(QPainter::SmoothPixmapTransform, false);
        p.drawImage(canvas->rect(), m_pix);
    }
    p.setPen(QColor(0, 230, 0));
    QFont f = font();
    p.setFont(f);
    const QFontMetrics fm(f);
    const int cw = qMax(8, fm.horizontalAdvance(QLatin1Char('M')));
    const int ch = qMax(14, fm.lineSpacing());
    m_cellW = cw;
    m_cellH = ch;
    const int limit = qMin(m_cells.size(), m_cols * m_rows);
    for (int i = 0; i < limit; ++i) {
        const char chv = m_cells.at(i);
        if (chv == ' ' || chv == '\0')
            continue;
        const int col = i % m_cols;
        const int row = i / m_cols;
        const QChar qc = (static_cast<unsigned char>(chv) >= 32 &&
                          static_cast<unsigned char>(chv) < 127)
                             ? QLatin1Char(chv)
                             : QLatin1Char('?');
        p.drawText(col * cw, row * ch + fm.ascent(), QString(qc));
    }
}

void GraphicsWindow::forwardKey(QKeyEvent *event)
{
    keyPressEvent(event);
}

void GraphicsWindow::forwardMouse(QMouseEvent *event)
{
    noteMouse(event->position().toPoint(), event->buttons());
}

void GraphicsWindow::paintEvent(QPaintEvent *event)
{
    QWidget::paintEvent(event);
}

bool GraphicsWindow::eventFilter(QObject *watched, QEvent *event)
{
    return QWidget::eventFilter(watched, event);
}

void GraphicsWindow::keyPressEvent(QKeyEvent *event)
{
    if (event->key() == Qt::Key_Escape) {
        hide();
        android_gfx_note_closed();
        emit userClosed();
        event->accept();
        return;
    }
    if (event->key() == Qt::Key_Left) {
        android_gfx_push_key(203);
        event->accept();
        return;
    }
    if (event->key() == Qt::Key_Right) {
        android_gfx_push_key(205);
        event->accept();
        return;
    }
    if (event->key() == Qt::Key_Up) {
        android_gfx_push_key(200);
        event->accept();
        return;
    }
    if (event->key() == Qt::Key_Down) {
        android_gfx_push_key(208);
        event->accept();
        return;
    }
    const QString text = event->text();
    if (!text.isEmpty()) {
        const QChar c = text.at(0);
        if (c.unicode() > 0 && c.unicode() < 128 && c.unicode() != 27) {
            android_gfx_push_key(c.unicode());
            event->accept();
            return;
        }
    }
    QWidget::keyPressEvent(event);
}

void GraphicsWindow::noteMouse(const QPoint &pos, Qt::MouseButtons buttons)
{
    const int pw = qMax(1, m_hasPix && m_pixW > 0 ? m_pixW : m_cols * 8);
    const int ph = qMax(1, m_hasPix && m_pixH > 0 ? m_pixH : m_rows * 16);
    const int viewW = qMax(1, m_canvas->width());
    const int viewH = qMax(1, m_canvas->height());
    long long px = (long long)pos.x() * pw / viewW;
    long long py = (long long)ph - 1 - ((long long)pos.y() * ph / viewH);
    if (px < 0)
        px = 0;
    if (py < 0)
        py = 0;
    long long b = 0;
    if (buttons & Qt::LeftButton)
        b |= 1;
    if (buttons & Qt::RightButton)
        b |= 2;
    if (buttons & Qt::MiddleButton)
        b |= 4;
    android_gfx_set_mouse(px, py, b);
}

void GraphicsWindow::mousePressEvent(QMouseEvent *event)
{
    noteMouse(event->position().toPoint(), event->buttons());
    setFocus(Qt::MouseFocusReason);
    event->accept();
}

void GraphicsWindow::mouseMoveEvent(QMouseEvent *event)
{
    noteMouse(event->position().toPoint(), event->buttons());
    event->accept();
}

void GraphicsWindow::mouseReleaseEvent(QMouseEvent *event)
{
    noteMouse(event->position().toPoint(), event->buttons());
    event->accept();
}

void GraphicsWindow::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);
    if (parentWidget() != nullptr && isVisible())
        setGeometry(parentWidget()->rect());
}
