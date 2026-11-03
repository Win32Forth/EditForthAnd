#pragma once

#include <QWidget>

class QCheckBox;
class QLabel;
class QLineEdit;
class QPlainTextEdit;
class QPushButton;

// Find and replace bar for the focused source editor or the console.
class FindBar : public QWidget {
    Q_OBJECT
public:
    explicit FindBar(QWidget *parent = nullptr);

    void attach(QPlainTextEdit *edit);
    void showFind();
    void showReplace();
    void findNext();
    void findPrevious();
    void useSelection();
    void replaceOne();
    void replaceSelection();
    void replaceAll();
    void setReplaceEnabled(bool on);

private:
    bool find(bool backward);
    void rememberEditor();
    void rememberNeedle();
    void updateCount();

    QPlainTextEdit *m_edit = nullptr;
    QLineEdit *m_find = nullptr;
    QLineEdit *m_replace = nullptr;
    QCheckBox *m_case = nullptr;
    QCheckBox *m_word = nullptr;
    QLabel *m_count = nullptr;
    QWidget *m_replaceRow = nullptr;
    QPushButton *m_replaceOne = nullptr;
    QPushButton *m_replaceAll = nullptr;
    bool m_replaceEnabled = true;
};
