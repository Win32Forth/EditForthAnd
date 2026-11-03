#include "ForthConsole.h"

#include "ViewClick.h"
#include "WheelScroll.h"

#include <QContextMenuEvent>
#include <QDateTime>
#include <QFont>
#include <QGuiApplication>
#include <QClipboard>
#include <QInputMethodEvent>
#include <QKeyEvent>
#include <QMenu>
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
    // 0x2000 is Qt::ImhNoFullscreen. It keeps Gboard from opening a separate
    // field that skips this widget's Enter and Backspace handling. The name
    // is missing from some Qt 6.4 headers; Qt 6.8+ publishes it. Hardware
    // keys still arrive here.
    setInputMethodHints(Qt::ImhNoPredictiveText | Qt::ImhNoAutoUppercase |
                        Qt::ImhPreferLatin | static_cast<Qt::InputMethodHint>(0x2000));
    setFocusPolicy(Qt::StrongFocus);
    setAttribute(Qt::WA_InputMethodEnabled, true);
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

static QString forthTokenAt(const QString &text, int position)
{
    if (position < 0 || text.isEmpty())
        return {};
    if (position >= text.size())
        --position;
    if (position < 0 || text.at(position).isSpace())
        return {};
    int start = position;
    int end = position + 1;
    while (start > 0 && !text.at(start - 1).isSpace())
        --start;
    while (end < text.size() && !text.at(end).isSpace())
        ++end;
    return text.mid(start, end - start);
}

void ForthConsole::mousePressEvent(QMouseEvent *event) {
    // Desktop: Ctrl-click. Android: Alt held (tracked app-wide — mouse events
    // often omit modifiers) because the emulator steals Ctrl+click for pinch.
    if (event->button() == Qt::LeftButton && isViewMouseClick(event)) {
        const QTextCursor cursor = cursorForPosition(event->position().toPoint());
        const QString word = forthTokenAt(toPlainText(), cursor.position());
        if (!word.isEmpty())
            emit viewWordRequested(word);
        event->accept();
        return;
    }
    QPlainTextEdit::mousePressEvent(event);
}

void ForthConsole::contextMenuEvent(QContextMenuEvent *event)
{
    const QPoint viewportPos = viewport()->mapFrom(this, event->pos());
    setTextCursor(cursorForPosition(viewportPos));
    const QString word = forthTokenAt(toPlainText(), textCursor().position());
    QMenu menu(this);
    QAction *view = menu.addAction(QStringLiteral("View Word"));
    view->setEnabled(!word.isEmpty());
#ifdef Q_OS_ANDROID
    view->setText(QStringLiteral("View Word (or View mode / Alt+click)"));
#endif
    menu.addSeparator();
    QAction *copy = menu.addAction(QStringLiteral("Copy"));
    QAction *paste = menu.addAction(QStringLiteral("Paste"));
    paste->setEnabled(m_alive && !m_locked);
    QAction *chosen = menu.exec(event->globalPos());
    if (chosen == view && !word.isEmpty())
        emit viewWordRequested(word);
    else if (chosen == copy)
        copySelection();
    else if (chosen == paste)
        pasteClipboard();
}

void ForthConsole::replaceInput(const QString &text) {
    QTextCursor cursor(document());
    cursor.setPosition(m_prot);
    cursor.movePosition(QTextCursor::End, QTextCursor::KeepAnchor);
    cursor.insertText(text);
    setTextCursor(cursor);
}

void ForthConsole::placeCursorInInput() {
    QTextCursor cursor = textCursor();
    if (!inputOnly(cursor)) {
        cursor.setPosition(toPlainText().size());
        setTextCursor(cursor);
    }
}

void ForthConsole::insertInputText(const QString &text) {
    if (!m_alive || m_locked || text.isEmpty())
        return;
    applyCommit(text);
    setFocus();
}

void ForthConsole::backspaceInput() {
    if (!m_alive || m_locked)
        return;
    placeCursorInInput();
    QTextCursor cursor = textCursor();
    if (cursor.position() <= m_prot && !cursor.hasSelection())
        return;
    if (cursor.hasSelection() && cursor.selectionStart() < m_prot)
        return;
    cursor.deletePreviousChar();
    setTextCursor(cursor);
    setFocus();
}

void ForthConsole::submitLine() {
    if (!m_alive || m_locked)
        return;
    if (toPlainText().mid(m_prot).isEmpty() && recentlySubmitted())
        return;
    submit();
    setFocus();
}

void ForthConsole::historyOlder() {
    if (!m_alive || m_locked || m_history.isEmpty())
        return;
    if (m_history_at < 0) {
        m_history_saved = toPlainText().mid(m_prot);
        m_history_at = m_history.size() - 1;
    } else if (m_history_at > 0) {
        m_history_at--;
    }
    replaceInput(m_history.at(m_history_at));
    setFocus();
}

void ForthConsole::historyNewer() {
    if (!m_alive || m_locked || m_history_at < 0)
        return;
    m_history_at++;
    if (m_history_at >= m_history.size()) {
        m_history_at = -1;
        replaceInput(m_history_saved);
    } else {
        replaceInput(m_history.at(m_history_at));
    }
    setFocus();
}

void ForthConsole::copySelection() {
    QTextCursor cursor = textCursor();
    QString text = cursor.hasSelection() ? cursor.selectedText() : toPlainText().mid(m_prot);
    text.replace(QChar(0x2029), QLatin1Char('\n'));
    if (text.isEmpty())
        return;
    QGuiApplication::clipboard()->setText(text);
}

void ForthConsole::pasteClipboard() {
    if (!m_alive || m_locked)
        return;
    const QString text = QGuiApplication::clipboard()->text();
    if (text.isEmpty())
        return;
    applyCommit(text);
    setFocus();
}

void ForthConsole::moveEditCursor(int key) {
    QKeyEvent event(QEvent::KeyPress, key, Qt::NoModifier);
    if (key == Qt::Key_Up || key == Qt::Key_Down || key == Qt::Key_Left ||
        key == Qt::Key_Right || key == Qt::Key_Home || key == Qt::Key_End) {
        QPlainTextEdit::keyPressEvent(&event);
    }
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
    m_lastSubmitMs = QDateTime::currentMSecsSinceEpoch();
    emit submitted(line);
}

bool ForthConsole::recentlySubmitted() const {
    return QDateTime::currentMSecsSinceEpoch() - m_lastSubmitMs < 250;
}

bool ForthConsole::applyCommit(const QString &text) {
    QString rest = text;
    rest.replace(QStringLiteral("\r\n"), QStringLiteral("\n"));
    rest.replace(QLatin1Char('\r'), QLatin1Char('\n'));
    if ((rest == QLatin1String("\n") || rest.isEmpty()) &&
        toPlainText().mid(m_prot).isEmpty() && recentlySubmitted())
        return true;
    bool submitted = false;
    while (true) {
        const int cut = rest.indexOf(QLatin1Char('\n'));
        if (cut < 0) {
            if (!rest.isEmpty()) {
                placeCursorInInput();
                QTextCursor cursor = textCursor();
                cursor.insertText(rest);
                setTextCursor(cursor);
            }
            break;
        }
        const QString prefix = rest.left(cut);
        if (!prefix.isEmpty()) {
            placeCursorInInput();
            QTextCursor cursor = textCursor();
            cursor.insertText(prefix);
            setTextCursor(cursor);
        }
        submit();
        submitted = true;
        rest = rest.mid(cut + 1);
    }
    return submitted;
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
    if (!commit.isEmpty()) {
        applyCommit(commit);
        event->accept();
        return;
    }
    // Some IMEs delete with a replacement and no commit string.
    if (event->replacementLength() > 0 && event->preeditString().isEmpty()) {
        placeCursorInInput();
        QTextCursor cursor = textCursor();
        if (!cursor.hasSelection() && cursor.position() <= m_prot) {
            event->accept();
            return;
        }
        if (cursor.hasSelection() && cursor.selectionStart() < m_prot) {
            event->accept();
            return;
        }
    }
    placeCursorInInput();
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

    if (event->key() == Qt::Key_Tab) {
        insertInputText(QStringLiteral(" "));
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
        // A soft keyboard often sends both this key and an IME newline.
        if (toPlainText().mid(m_prot).isEmpty() && recentlySubmitted())
            return;
        submit();
        return;
    }
    if (event->text().contains(QLatin1Char('\n')) || event->text().contains(QLatin1Char('\r'))) {
        applyCommit(event->text());
        return;
    }
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
    if (event->key() == Qt::Key_Up && (event->modifiers() & Qt::ControlModifier) == 0) {
        historyOlder();
        return;
    }
    if (event->key() == Qt::Key_Down && (event->modifiers() & Qt::ControlModifier) == 0) {
        historyNewer();
        return;
    }
    if (event->matches(QKeySequence::Cut))
        return;
    QPlainTextEdit::keyPressEvent(event);
}

void ForthConsole::insertFromMimeData(const QMimeData *source) {
    if (!m_alive || m_locked || source == NULL || !source->hasText())
        return;
    applyCommit(source->text());
}
