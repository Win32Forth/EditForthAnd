#include "WheelScroll.h"

#include "ViewClick.h"

#include <QAbstractScrollArea>
#include <QApplication>
#include <QEvent>
#include <QInputEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QPointer>
#include <QScrollBar>
#include <QWheelEvent>
#include <QWidget>

#ifdef Q_OS_ANDROID
#include <android/log.h>
#define EF_WHEEL_LOG(...) \
    __android_log_print(ANDROID_LOG_INFO, "EditForthAnd", __VA_ARGS__)
#else
#define EF_WHEEL_LOG(...) \
    do {                  \
    } while (0)
#endif

bool applyWheelToScrollBar(QScrollBar *bar, QWheelEvent *event) {
    if (bar == nullptr || event == nullptr)
        return false;
    int dy = 0;
    const QPoint pixels = event->pixelDelta();
    const QPoint degrees = event->angleDelta();
    if (!pixels.isNull()) {
        dy = pixels.y();
    } else if (degrees.y() != 0) {
        const int eighths = degrees.y() / 8;
        if (eighths != 0)
            dy = eighths * qMax(1, bar->singleStep());
        else
            dy = (degrees.y() > 0 ? 1 : -1) * qMax(1, bar->pageStep());
    }
    if (dy == 0)
        return false;
    const int before = bar->value();
    bar->setValue(before - dy);
    event->accept();
    return bar->value() != before || bar->maximum() > bar->minimum();
}

bool applyWheelToScrollArea(QAbstractScrollArea *area, QWheelEvent *event) {
    if (area == nullptr || event == nullptr)
        return false;
    if (event->modifiers() & Qt::ShiftModifier)
        return applyWheelToScrollBar(area->horizontalScrollBar(), event);
    return applyWheelToScrollBar(area->verticalScrollBar(), event);
}

namespace {

bool g_panMode = false;
bool g_shiftHeld = false;
bool g_dragging = false;
Qt::MouseButton g_dragButton = Qt::NoButton;
QPoint g_lastGlobal;
QPointer<QAbstractScrollArea> g_dragArea;

QAbstractScrollArea *scrollAreaFrom(QObject *receiver, const QPoint &globalPos) {
    if (auto *widget = qobject_cast<QWidget *>(receiver)) {
        for (QWidget *w = widget; w != nullptr; w = w->parentWidget()) {
            if (auto *area = qobject_cast<QAbstractScrollArea *>(w))
                return area;
        }
    }
    QWidget *under = QApplication::widgetAt(globalPos);
    for (QWidget *w = under; w != nullptr; w = w->parentWidget()) {
        if (auto *area = qobject_cast<QAbstractScrollArea *>(w))
            return area;
    }
    return nullptr;
}

bool scrollAreaByPixels(QAbstractScrollArea *area, int dx, int dy) {
    if (area == nullptr || (dx == 0 && dy == 0))
        return false;
    bool moved = false;
    if (dy != 0) {
        if (QScrollBar *bar = area->verticalScrollBar()) {
            const int before = bar->value();
            bar->setValue(before - dy);
            moved = moved || bar->value() != before;
        }
    }
    if (dx != 0) {
        if (QScrollBar *bar = area->horizontalScrollBar()) {
            const int before = bar->value();
            bar->setValue(before - dx);
            moved = moved || bar->value() != before;
        }
    }
    return moved;
}

bool panChordActive(const QInputEvent *event) {
    // Alt is reserved for VIEW (see ViewClick.h). Pan uses the Pan button
    // and/or Shift — not Alt.
    if (g_panMode || g_shiftHeld)
        return true;
    if (event == nullptr)
        return false;
    return (event->modifiers() & Qt::ShiftModifier) != 0;
}

void endDrag(QObject *receiver) {
    g_dragging = false;
    g_dragButton = Qt::NoButton;
    g_dragArea.clear();
    if (auto *w = qobject_cast<QWidget *>(receiver))
        w->unsetCursor();
}

bool startDrag(QObject *receiver, QMouseEvent *me, Qt::MouseButton button) {
    QAbstractScrollArea *area = scrollAreaFrom(receiver, me->globalPosition().toPoint());
    if (area == nullptr)
        return false;
    g_dragArea = area;
    g_lastGlobal = me->globalPosition().toPoint();
    g_dragging = true;
    g_dragButton = button;
    if (auto *w = qobject_cast<QWidget *>(receiver))
        w->setCursor(Qt::ClosedHandCursor);
    EF_WHEEL_LOG("pan-drag start btn=%d area=%s panMode=%d shift=%d", int(button),
                 area->metaObject()->className(), int(g_panMode), int(g_shiftHeld));
    return true;
}

bool handleMousePan(QObject *receiver, QEvent *event) {
    switch (event->type()) {
    case QEvent::KeyPress: {
        auto *ke = static_cast<QKeyEvent *>(event);
        if (!ke->isAutoRepeat() && ke->key() == Qt::Key_Shift)
            g_shiftHeld = true;
        return false;
    }
    case QEvent::KeyRelease: {
        auto *ke = static_cast<QKeyEvent *>(event);
        if (!ke->isAutoRepeat() && ke->key() == Qt::Key_Shift) {
            g_shiftHeld = false;
            if (g_dragging && g_dragButton == Qt::LeftButton && !g_panMode)
                endDrag(receiver);
        }
        return false;
    }
    case QEvent::MouseButtonPress: {
        auto *me = static_cast<QMouseEvent *>(event);
        if (me->button() == Qt::MiddleButton)
            return startDrag(receiver, me, Qt::MiddleButton);
        // Let Alt/Meta VIEW clicks reach CodeEdit / ForthConsole.
        if (me->button() == Qt::LeftButton && isViewMouseClick(me))
            return false;
        if (me->button() == Qt::LeftButton && panChordActive(me))
            return startDrag(receiver, me, Qt::LeftButton);
        return false;
    }
    case QEvent::MouseMove: {
        if (!g_dragging || g_dragArea.isNull())
            return false;
        auto *me = static_cast<QMouseEvent *>(event);
        if (!(me->buttons() & g_dragButton)) {
            endDrag(receiver);
            return true;
        }
        const QPoint global = me->globalPosition().toPoint();
        const QPoint delta = global - g_lastGlobal;
        g_lastGlobal = global;
        scrollAreaByPixels(g_dragArea.data(), delta.x(), delta.y());
        return true;
    }
    case QEvent::MouseButtonRelease: {
        auto *me = static_cast<QMouseEvent *>(event);
        if (!g_dragging || me->button() != g_dragButton)
            return false;
        endDrag(receiver);
        return true;
    }
    default:
        return false;
    }
}

class AndroidWheelFilter final : public QObject {
public:
    using QObject::QObject;

protected:
    bool eventFilter(QObject *watched, QEvent *event) override {
        if (event->type() == QEvent::Wheel) {
            auto *we = static_cast<QWheelEvent *>(event);
            QAbstractScrollArea *area =
                scrollAreaFrom(watched, we->globalPosition().toPoint());
            if (area != nullptr && applyWheelToScrollArea(area, we))
                return true;
        }
        if (event->type() == QEvent::KeyPress || event->type() == QEvent::KeyRelease)
            handleMousePan(watched, event);
        return QObject::eventFilter(watched, event);
    }
};

} // namespace

void setAndroidPanMode(bool on) {
    g_panMode = on;
    EF_WHEEL_LOG("pan mode %s", on ? "on" : "off");
    if (!on && g_dragging && g_dragButton == Qt::LeftButton && !g_shiftHeld) {
        g_dragging = false;
        g_dragButton = Qt::NoButton;
        g_dragArea.clear();
    }
}

bool androidPanMode() { return g_panMode; }

bool handleAndroidScrollNotify(QObject *receiver, QEvent *event) {
    if (event == nullptr)
        return false;
    if (event->type() == QEvent::Wheel) {
        auto *we = static_cast<QWheelEvent *>(event);
        QAbstractScrollArea *area = scrollAreaFrom(receiver, we->globalPosition().toPoint());
        if (area != nullptr && applyWheelToScrollArea(area, we))
            return true;
        return false;
    }
    return handleMousePan(receiver, event);
}

void installAndroidWheelScrollFilter(QObject *app) {
    if (app == nullptr)
        return;
    static AndroidWheelFilter *filter = nullptr;
    if (filter == nullptr) {
        filter = new AndroidWheelFilter(app);
        app->installEventFilter(filter);
    }
}
