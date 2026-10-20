#ifndef EDITFORTHAND_WHEELSCROLL_H
#define EDITFORTHAND_WHEELSCROLL_H

class QAbstractScrollArea;
class QEvent;
class QObject;
class QScrollBar;
class QWheelEvent;

bool applyWheelToScrollBar(QScrollBar *bar, QWheelEvent *event);
bool applyWheelToScrollArea(QAbstractScrollArea *area, QWheelEvent *event);

// Android: wheel is rarely delivered by the Mac emulator. Install once on
// QApplication. Pan via the Pan button / View→Pan scroll (left-drag). Middle
// button drag is kept for devices that deliver it.
void installAndroidWheelScrollFilter(QObject *app);
bool handleAndroidScrollNotify(QObject *receiver, QEvent *event);
void setAndroidPanMode(bool on);
bool androidPanMode();

#endif
