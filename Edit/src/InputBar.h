#pragma once

#include <QWidget>

class QPushButton;

// Touch row for Forth symbols, arrows, history, and edit keys.
// Buttons do not take focus, so a hardware keyboard stays in the editor
// or the console.
class InputBar : public QWidget {
    Q_OBJECT
public:
    explicit InputBar(QWidget *parent = nullptr);

    bool controlHeld() const { return m_control; }

signals:
    void insertText(const QString &text);
    void backspacePressed();
    void enterPressed();
    void escapePressed();
    void tabPressed();
    void arrowPressed(int key);
    void historyOlder();
    void historyNewer();
    void historyMenu();
    void copyPressed();
    void pastePressed();
    void findPressed();
    void splitPressed();
    void viewPressed();

private:
    void addKey(class QWidget *row, const QString &label, const QString &tip, int width = 0);
    void toggleControl();

    bool m_control = false;
    QPushButton *m_ctrl = nullptr;
};
