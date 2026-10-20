#include "MainWindow.h"
#ifdef Q_OS_ANDROID
#include "WheelScroll.h"

#include <QEvent>
#endif

#include <QApplication>

#ifdef Q_OS_ANDROID
class EditForthApplication final : public QApplication {
public:
    using QApplication::QApplication;

    bool notify(QObject *receiver, QEvent *event) override {
        // Consume wheel / Shift+drag before CodeEdit/ForthConsole start a
        // text selection. Emulator mouse events often omit ShiftModifier.
        if (handleAndroidScrollNotify(receiver, event))
            return true;
        return QApplication::notify(receiver, event);
    }
};
#endif

int main(int argc, char *argv[]) {
    Q_UNUSED(argc);
    Q_UNUSED(argv);
#ifdef Q_OS_ANDROID
    EditForthApplication app(argc, argv);
    QApplication::setApplicationName(QStringLiteral("EditForthAnd"));
    installAndroidWheelScrollFilter(&app);
#else
    QApplication app(argc, argv);
    QApplication::setApplicationName(QStringLiteral("EditForthWin"));
#endif
    QApplication::setOrganizationName(QStringLiteral("Win32Forth"));

    MainWindow window;
#ifndef Q_OS_ANDROID
    window.resize(960, 700);
#endif
    window.show();

    const QStringList args = QApplication::arguments();
    for (int i = 1; i < args.size(); ++i)
        window.openFile(args.at(i));
    if (window.tabCount() == 0)
        window.newFile();

    return app.exec();
}
