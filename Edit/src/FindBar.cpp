#include "FindBar.h"

#include <QAbstractItemModel>
#include <QCheckBox>
#include <QCompleter>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QPlainTextEdit>
#include <QPushButton>
#include <QSettings>
#include <QStringList>
#include <QStringListModel>
#include <QTextCursor>
#include <QTextDocument>
#include <QVBoxLayout>

namespace {

QStringList loadHistory()
{
    return QSettings().value(QStringLiteral("findHistory")).toStringList();
}

void saveHistory(const QStringList &history)
{
    QSettings().setValue(QStringLiteral("findHistory"), history);
}

} // namespace

FindBar::FindBar(QWidget *parent) : QWidget(parent) {
    m_find = new QLineEdit(this);
    m_find->setPlaceholderText(QStringLiteral("Find"));
    auto *completer = new QCompleter(loadHistory(), m_find);
    completer->setCaseSensitivity(Qt::CaseInsensitive);
    completer->setCompletionMode(QCompleter::PopupCompletion);
    m_find->setCompleter(completer);
    m_replace = new QLineEdit(this);
    m_replace->setPlaceholderText(QStringLiteral("Replace"));
    m_case = new QCheckBox(QStringLiteral("Case"), this);
    m_word = new QCheckBox(QStringLiteral("Word"), this);
    m_count = new QLabel(this);
    m_count->setMinimumWidth(72);

    auto *findRow = new QHBoxLayout;
    findRow->setContentsMargins(6, 4, 6, 2);
    findRow->addWidget(new QLabel(QStringLiteral("Find"), this));
    findRow->addWidget(m_find, 1);
    auto *next = new QPushButton(QStringLiteral("Next"), this);
    auto *prev = new QPushButton(QStringLiteral("Previous"), this);
    findRow->addWidget(prev);
    findRow->addWidget(next);
    findRow->addWidget(m_case);
    findRow->addWidget(m_word);
    findRow->addWidget(m_count);
    auto *close = new QPushButton(QStringLiteral("Close"), this);
    findRow->addWidget(close);

    m_replaceRow = new QWidget(this);
    auto *replaceRow = new QHBoxLayout(m_replaceRow);
    replaceRow->setContentsMargins(6, 2, 6, 4);
    replaceRow->addWidget(new QLabel(QStringLiteral("Replace"), m_replaceRow));
    replaceRow->addWidget(m_replace, 1);
    m_replaceOne = new QPushButton(QStringLiteral("Replace"), m_replaceRow);
    m_replaceAll = new QPushButton(QStringLiteral("Replace All"), m_replaceRow);
    replaceRow->addWidget(m_replaceOne);
    replaceRow->addWidget(m_replaceAll);

    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(0, 0, 0, 0);
    box->setSpacing(0);
    box->addLayout(findRow);
    box->addWidget(m_replaceRow);
    setStyleSheet(QStringLiteral("background: #f4f1e8;"));

    connect(m_find, &QLineEdit::returnPressed, this, &FindBar::findNext);
    connect(m_find, &QLineEdit::textChanged, this, [this](const QString &) { updateCount(); });
    connect(m_case, &QCheckBox::toggled, this, [this](bool) { updateCount(); });
    connect(m_word, &QCheckBox::toggled, this, [this](bool) { updateCount(); });
    connect(next, &QPushButton::clicked, this, &FindBar::findNext);
    connect(prev, &QPushButton::clicked, this, &FindBar::findPrevious);
    connect(m_replaceOne, &QPushButton::clicked, this, &FindBar::replaceOne);
    connect(m_replaceAll, &QPushButton::clicked, this, &FindBar::replaceAll);
    connect(close, &QPushButton::clicked, this, &QWidget::hide);
}

void FindBar::attach(QPlainTextEdit *edit) { m_edit = edit; }

void FindBar::setReplaceEnabled(bool on) {
    m_replaceEnabled = on;
    if (m_replace != nullptr)
        m_replace->setEnabled(on);
    if (m_replaceOne != nullptr)
        m_replaceOne->setEnabled(on);
    if (m_replaceAll != nullptr)
        m_replaceAll->setEnabled(on);
    if (m_replaceRow != nullptr) {
        m_replaceRow->setToolTip(on ? QString()
                                    : QStringLiteral("Replace applies to a source tab."));
    }
}

void FindBar::rememberEditor() {
    if (m_edit != nullptr)
        m_edit->setFocus();
}

void FindBar::rememberNeedle() {
    const QString needle = m_find->text();
    if (needle.isEmpty())
        return;
    QStringList history = loadHistory();
    history.removeAll(needle);
    history.prepend(needle);
    while (history.size() > 16)
        history.removeLast();
    saveHistory(history);
    if (auto *completer = m_find->completer()) {
        auto *model = new QStringListModel(history, completer);
        QAbstractItemModel *previous = completer->model();
        completer->setModel(model);
        if (previous != nullptr && previous->parent() == completer)
            previous->deleteLater();
    }
}

void FindBar::showFind() {
    m_replaceRow->show();
    show();
    m_find->setFocus();
    m_find->selectAll();
    updateCount();
}

void FindBar::showReplace() {
    m_replaceRow->show();
    show();
    if (m_replaceEnabled)
        m_replace->setFocus();
    else
        m_find->setFocus();
    m_find->selectAll();
    updateCount();
}

void FindBar::useSelection() {
    if (m_edit == nullptr)
        return;
    const QString selected = m_edit->textCursor().selectedText();
    if (selected.isEmpty() || selected.contains(QChar(0x2029)))
        return;
    m_find->setText(selected);
    showFind();
}

static QTextDocument::FindFlags flagsFor(bool backward, bool matchCase, bool wholeWord)
{
    QTextDocument::FindFlags flags;
    if (backward)
        flags |= QTextDocument::FindBackward;
    if (matchCase)
        flags |= QTextDocument::FindCaseSensitively;
    if (wholeWord)
        flags |= QTextDocument::FindWholeWords;
    return flags;
}

void FindBar::updateCount() {
    if (m_count == nullptr)
        return;
    if (m_edit == nullptr || m_find->text().isEmpty()) {
        m_count->clear();
        return;
    }
    const QString needle = m_find->text();
    QTextDocument::FindFlags flags;
    if (m_case->isChecked())
        flags |= QTextDocument::FindCaseSensitively;
    if (m_word->isChecked())
        flags |= QTextDocument::FindWholeWords;
    int total = 0;
    int current = 0;
    const int caret = m_edit->textCursor().selectionStart();
    QTextCursor cursor(m_edit->document());
    cursor.movePosition(QTextCursor::Start);
    while (true) {
        cursor = m_edit->document()->find(needle, cursor, flags);
        if (cursor.isNull())
            break;
        ++total;
        if (cursor.selectionStart() <= caret)
            current = total;
        if (total > 100000)
            break;
    }
    if (total == 0)
        m_count->setText(QStringLiteral("No matches"));
    else
        m_count->setText(QStringLiteral("%1 of %2").arg(current).arg(total));
}

bool FindBar::find(bool backward) {
    if (m_edit == nullptr)
        return false;
    const QString needle = m_find->text();
    if (needle.isEmpty())
        return false;
    rememberNeedle();
    const QTextDocument::FindFlags flags =
        flagsFor(backward, m_case->isChecked(), m_word->isChecked());
    if (m_edit->find(needle, flags)) {
        updateCount();
        return true;
    }
    QTextCursor cursor = m_edit->textCursor();
    cursor.movePosition(backward ? QTextCursor::End : QTextCursor::Start);
    m_edit->setTextCursor(cursor);
    const bool found = m_edit->find(needle, flags);
    updateCount();
    return found;
}

void FindBar::findNext() { find(false); }

void FindBar::findPrevious() { find(true); }

void FindBar::replaceSelection() {
    if (!m_replaceEnabled || m_edit == nullptr || m_edit->isReadOnly())
        return;
    QTextCursor cursor = m_edit->textCursor();
    if (!cursor.hasSelection())
        return;
    const QString selected = cursor.selectedText();
    const QString needle = m_find->text();
    const bool same = m_case->isChecked() ? selected == needle
                                           : selected.compare(needle, Qt::CaseInsensitive) == 0;
    if (same)
        cursor.insertText(m_replace->text());
}

void FindBar::replaceOne() {
    replaceSelection();
    findNext();
}

void FindBar::replaceAll() {
    if (!m_replaceEnabled || m_edit == nullptr || m_edit->isReadOnly())
        return;
    const QString needle = m_find->text();
    if (needle.isEmpty())
        return;
    QTextDocument::FindFlags flags;
    if (m_case->isChecked())
        flags |= QTextDocument::FindCaseSensitively;
    if (m_word->isChecked())
        flags |= QTextDocument::FindWholeWords;
    QTextCursor cursor(m_edit->document());
    cursor.beginEditBlock();
    int count = 0;
    cursor.movePosition(QTextCursor::Start);
    while (true) {
        cursor = m_edit->document()->find(needle, cursor, flags);
        if (cursor.isNull())
            break;
        cursor.insertText(m_replace->text());
        ++count;
        if (count > 100000)
            break;
    }
    cursor.endEditBlock();
    updateCount();
}
