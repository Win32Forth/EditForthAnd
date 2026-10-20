#pragma once

#include <QGuiApplication>
#include <QInputEvent>
#include <QKeyEvent>

#include <atomic>

// Android emulator: Ctrl+click is pinch-zoom; mouse events often omit Alt even
// when Option/Alt is held on the host. Track Alt/Meta from key events app-wide,
// offer a sticky View-mode strip button (like Pan), and combine with
// queryKeyboardModifiers for VIEW clicks.

inline std::atomic<bool> &viewModHeld()
{
    static std::atomic<bool> held{false};
    return held;
}

inline std::atomic<bool> &androidViewMode()
{
    static std::atomic<bool> on{false};
    return on;
}

inline void setAndroidViewMode(bool on)
{
    androidViewMode().store(on);
}

inline void noteViewModKey(const QKeyEvent *event, bool down)
{
    if (event == nullptr)
        return;
    switch (event->key()) {
    case Qt::Key_Alt:
    case Qt::Key_AltGr:
    case Qt::Key_Meta:
        viewModHeld().store(down);
        return;
    default:
        break;
    }
    // Some hosts only put Alt on modifiers of other key events.
    if (down) {
        const Qt::KeyboardModifiers mods =
            event->modifiers() | QGuiApplication::queryKeyboardModifiers();
        if ((mods & (Qt::AltModifier | Qt::MetaModifier)) != 0)
            viewModHeld().store(true);
    } else if ((event->modifiers() & (Qt::AltModifier | Qt::MetaModifier)) == 0 &&
               (QGuiApplication::queryKeyboardModifiers() &
                (Qt::AltModifier | Qt::MetaModifier)) == 0) {
        viewModHeld().store(false);
    }
}

inline bool isViewMouseClick(const QInputEvent *event)
{
    if (event == nullptr)
        return false;
#ifdef Q_OS_ANDROID
    if (androidViewMode().load())
        return true;
    const Qt::KeyboardModifiers mods =
        event->modifiers() | QGuiApplication::queryKeyboardModifiers();
    return viewModHeld().load() ||
           (mods & (Qt::AltModifier | Qt::MetaModifier)) != 0;
#else
    return (event->modifiers() & (Qt::ControlModifier | Qt::MetaModifier)) != 0;
#endif
}
