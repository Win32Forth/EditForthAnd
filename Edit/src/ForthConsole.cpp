#include "ForthConsole.h"

#include "WheelScroll.h"

#include <QFont>
#include <QInputMethodEvent>
#include <QKeyEvent>
#include <QMimeData>
#include <QMouseEvent>
#include <QScrollBar>
#include <QTextCursor>
#include <QWheelEvent>

ForthConsole::ForthConsole(QWidget *parent) : QPlainTextEdit(parent) {
    QFont font(QStringLiteral("Consolas"), 13);
    font.setStyleHint(QFont::Monospace);
    font.setFixedPitch(true);
    setFont(font);
    setLineWrapMode(QPlainTextEdit::WidgetWidth);
    setUndoRedoEnabled(false);
    setAccessibleName(QStringLiteral("Forth console"));
    // Soft keyboards: prefer an action key over inserting a raw newline.
    setInputMethodHints(Qt::ImhNoPredictiveText | Qt::ImhNoAutoUppercase |
                        Qt::ImhPreferLatin);
    // Android often hides scrollbars; keep one so scroll is possible without a wheel.
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOn);
    // Wheel events land on the viewport, not always on this widget.
    viewport()->installEventFilter(this);
    setEngineAlive(false);
}

void ForthConsole::setEngineAlive(bool alive) {
    m_alive = alive;
    setReadOnly(!alive);
}

void ForthConsole::setInputLocked(bool locked) { m_locked = locked; }

void ForthConsole::appendOutput(const QString &text) {
    if (text.isEmpty())
        return;
    QTextCursor cursor(document());
    cursor.setPosition(m_prot);
    cursor.insertText(text);
    m_prot += text.size();
    cursor.setPosition(toPlainText().size());
    setTextCursor(cursor);
    verticalScrollBar()->setValue(verticalScrollBar()->maximum());
}

void ForthConsole::fillInput(const QString &text) {
    replaceInput(text);
    QTextCursor cursor = textCursor();
    cursor.movePosition(QTextCursor::End);
    setTextCursor(cursor);
    setFocus();
}

void ForthConsole::clearDisplay() {
    clear();
    m_prot = 0;
    m_commit_at = -1;
    m_commit_n = 0;
}

void ForthConsole::setPointSize(int points) {
    QFont next = font();
    next.setPointSize(qBound(9, points, 32));
    setFont(next);
}

bool ForthConsole::scrollByWheel(QWheelEvent *event) {
    return applyWheelToScrollArea(this, event);
}

bool ForthConsole::eventFilter(QObject *watched, QEvent *event) {
    if (watched == viewport() && event->type() == QEvent::Wheel &&
        applyWheelToScrollArea(this, static_cast<QWheelEvent *>(event)))
        return true;
    return QPlainTextEdit::eventFilter(watched, event);
}

void ForthConsole::wheelEvent(QWheelEvent *event) {
    if (scrollByWheel(event))
        return;
    QPlainTextEdit::wheelEvent(event);
}

void ForthConsole::mousePressEvent(QMouseEvent *event) {
    // Desktop uses Ctrl; macOS Command is Qt::ControlModifier in-app, but the
    // Android emulator may deliver Command as Meta — accept either.
    const bool viewClick =
        event->button() == Qt::LeftButton &&
        (event->modifiers() & (Qt::ControlModifier | Qt::MetaModifier));
    if (viewClick) {
        const QTextCursor cursor = cursorForPosition(event->position().toPoint());
        const QString text = toPlainText();
        int position = cursor.position();
        if (position < 0 || position > text.size() || text.isEmpty()) {
            QPlainTextEdit::mousePressEvent(event);
            return;
        }
        if (position == text.size())
            --position;
        if (position >= 0 && !text.at(position).isSpace()) {
            int start = position;
            int end = position + 1;
            while (start > 0 && !text.at(start - 1).isSpace())
                --start;
            while (end < text.size() && !text.at(end).isSpace())
                ++end;
            const QString word = text.mid(start, end - start);
            if (!word.isEmpty())
                emit viewWordRequested(word);
        }
        event->accept();
        return;
    }
    QPlainTextEdit::mousePressEvent(event);
}

void ForthConsole::replaceInput(const QString &text) {
    QTextCursor cursor(document());
    cursor.setPosition(m_prot);
    cursor.movePosition(QTextCursor::End, QTextCursor::KeepAnchor);
    cursor.insertText(text);
    setTextCursor(cursor);
}

bool ForthConsole::inputOnly(const QTextCursor &cursor) const {
    int a = cursor.selectionStart();
    int b = cursor.selectionEnd();
    if (a > b) {
        int t = a;
        a = b;
        b = t;
    }
    return a >= m_prot && b >= m_prot;
}

void ForthConsole::submit() {
    QString line = toPlainText().mid(m_prot);
    while (line.endsWith(QLatin1Char('\n')) || line.endsWith(QLatin1Char('\r')))
        line.chop(1);
    const QString committed = line + QStringLiteral("\n");
    replaceInput(QString());
    m_commit_at = m_prot;
    appendOutput(committed);
    m_commit_n = committed.size();
    if (!line.isEmpty()) {
        m_history.append(line);
        if (m_history.size() > 200)
            m_history.removeFirst();
    }
    m_history_at = -1;
    m_history_saved.clear();
    emit submitted(line);
}

bool ForthConsole::trySubmitFromText(const QString &text) {
    int cut = -1;
    for (int i = 0; i < text.size(); ++i) {
        const QChar ch = text.at(i);
        if (ch == QLatin1Char('\n') || ch == QLatin1Char('\r')) {
            cut = i;
            break;
        }
    }
    if (cut < 0)
        return false;
    const QString prefix = text.left(cut);
    if (!prefix.isEmpty()) {
        QTextCursor cursor = textCursor();
        if (!inputOnly(cursor)) {
            cursor.setPosition(toPlainText().size());
            setTextCursor(cursor);
            cursor = textCursor();
        }
        cursor.insertText(prefix);
    }
    submit();
    return true;
}

void ForthConsole::retractSubmit() {
    if (m_commit_n <= 0 || m_commit_at < 0 || m_commit_at + m_commit_n > m_prot)
        return;
    QString chunk = toPlainText().mid(m_commit_at, m_commit_n);
    QTextCursor cursor(document());
    cursor.setPosition(m_commit_at);
    cursor.setPosition(m_commit_at + m_commit_n, QTextCursor::KeepAnchor);
    cursor.removeSelectedText();
    m_prot -= m_commit_n;
    m_commit_at = -1;
    m_commit_n = 0;
    while (chunk.endsWith(QLatin1Char('\n')) || chunk.endsWith(QLatin1Char('\r')))
        chunk.chop(1);
    if (!m_history.isEmpty() && m_history.last() == chunk)
        m_history.removeLast();
    m_history_at = -1;
    m_history_saved.clear();
    replaceInput(chunk);
}

QVariant ForthConsole::inputMethodQuery(Qt::InputMethodQuery query) const {
    if (query == Qt::ImEnterKeyType)
        return QVariant::fromValue(Qt::EnterKeySend);
    return QPlainTextEdit::inputMethodQuery(query);
}

void ForthConsole::inputMethodEvent(QInputMethodEvent *event) {
    if (!m_alive || m_locked) {
        event->ignore();
        return;
    }
    const QString commit = event->commitString();
    if (!commit.isEmpty() && trySubmitFromText(commit)) {
        event->accept();
        return;
    }
    QTextCursor cursor = textCursor();
    if (!commit.isEmpty() && !inputOnly(cursor)) {
        cursor.setPosition(toPlainText().size());
        setTextCursor(cursor);
    }
    QPlainTextEdit::inputMethodEvent(event);
}

void ForthConsole::keyPressEvent(QKeyEvent *event) {
    if (event->matches(QKeySequence::Copy) || event->matches(QKeySequence::SelectAll)) {
        QPlainTextEdit::keyPressEvent(event);
        return;
    }
    if (!m_alive)
        return;
    if (m_locked) {
        switch (event->key()) {
        case Qt::Key_Left:
        case Qt::Key_Right:
        case Qt::Key_Up:
        case Qt::Key_Down:
        case Qt::Key_Home:
        case Qt::Key_End:
        case Qt::Key_PageUp:
        case Qt::Key_PageDown:
            QPlainTextEdit::keyPressEvent(event);
            break;
        default:
            break;
        }
        return;
    }

    QTextCursor cursor = textCursor();
    if (event->matches(QKeySequence::Paste) || event->key() == Qt::Key_Return ||
        event->key() == Qt::Key_Enter || event->key() == Qt::Key_Backspace ||
        event->key() == Qt::Key_Delete || !event->text().isEmpty()) {
        if (!inputOnly(cursor)) {
            cursor.setPosition(toPlainText().size());
            setTextCursor(cursor);
        }
    }

    if (event->key() == Qt::Key_Return || event->key() == Qt::Key_Enter) {
        submit();
        return;
    }
    if (trySubmitFromText(event->text()))
        return;
    if (event->key() == Qt::Key_Backspace) {
        cursor = textCursor();
        if (cursor.position() <= m_prot && !cursor.hasSelection())
            return;
        if (cursor.hasSelection() && cursor.selectionStart() < m_prot)
            return;
    }
    if (event->key() == Qt::Key_Delete) {
        cursor = textCursor();
        if (cursor.position() < m_prot)
            return;
        if (cursor.hasSelection() && cursor.selectionStart() < m_prot)
            return;
    }
    if (event->key() == Qt::Key_Up || event->key() == Qt::Key_Down) {
        if (m_history.isEmpty())
            return;
        if (event->key() == Qt::Key_Up) {
            if (m_history_at < 0) {
                m_history_saved = toPlainText().mid(m_prot);
                m_history_at = m_history.size() - 1;
            } else if (m_history_at > 0) {
                m_history_at--;
            }
            replaceInput(m_history.at(m_history_at));
        } else if (m_history_at >= 0) {
            m_history_at++;
            if (m_history_at >= m_history.size()) {
                m_history_at = -1;
                replaceInput(m_history_saved);
            } else {
                replaceInput(m_history.at(m_history_at));
            }
        }
        return;
    }
    if (event->matches(QKeySequence::Cut))
        return;
    QPlainTextEdit::keyPressEvent(event);
}

void ForthConsole::insertFromMimeData(const QMimeData *source) {
    if (!m_alive || m_locked || source == NULL)
        return;
    QTextCursor cursor = textCursor();
    if (!inputOnly(cursor)) {
        cursor.setPosition(toPlainText().size());
        setTextCursor(cursor);
    }
    QPlainTextEdit::insertFromMimeData(source);
}
