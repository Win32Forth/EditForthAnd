#include "InputBar.h"

#include <QFrame>
#include <QHBoxLayout>
#include <QPushButton>
#include <QScrollArea>
#include <QSizePolicy>
#include <QStringList>
#include <QVBoxLayout>

namespace {

QScrollArea *scroller(QWidget *row, QWidget *parent)
{
    auto *scroll = new QScrollArea(parent);
    scroll->setWidget(row);
    scroll->setWidgetResizable(true);
    scroll->setFrameShape(QFrame::NoFrame);
    scroll->setHorizontalScrollBarPolicy(Qt::ScrollBarAsNeeded);
    scroll->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    scroll->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
    scroll->setFixedHeight(56);
    scroll->setStyleSheet(QStringLiteral("QScrollArea { background: #eceff1; }"));
    return scroll;
}

} // namespace

InputBar::InputBar(QWidget *parent) : QWidget(parent)
{
    setFocusPolicy(Qt::NoFocus);
    setMinimumHeight(112);
    setStyleSheet(QStringLiteral("QPushButton { background: #ffffff; padding: 4px 6px; }"
                                 "QPushButton:checked { background: #ffe082; }"));

    auto *symbols = new QWidget(this);
    auto *actions = new QWidget(this);
    auto *symbolRow = new QHBoxLayout(symbols);
    auto *actionRow = new QHBoxLayout(actions);
    symbolRow->setContentsMargins(4, 2, 4, 0);
    actionRow->setContentsMargins(4, 0, 4, 2);
    symbolRow->setSpacing(4);
    actionRow->setSpacing(4);

    const QStringList forthKeys = {
        QStringLiteral(":"),  QStringLiteral(";"), QStringLiteral("\\"), QStringLiteral("\""),
        QStringLiteral("'"),  QStringLiteral("("), QStringLiteral(")"),  QStringLiteral("["),
        QStringLiteral("]"),  QStringLiteral("{"), QStringLiteral("}"),  QStringLiteral("@"),
        QStringLiteral("!"),  QStringLiteral("#"), QStringLiteral("$"),  QStringLiteral(","),
        QStringLiteral("."),  QStringLiteral("+"), QStringLiteral("-"),  QStringLiteral("*"),
        QStringLiteral("/"),  QStringLiteral("="), QStringLiteral("<"),  QStringLiteral(">"),
        QStringLiteral("DUP"), QStringLiteral("DROP"), QStringLiteral("SWAP"),
        QStringLiteral(".S"), QStringLiteral("CR"),
    };
    for (const QString &key : forthKeys)
        addKey(symbols, key, key);

    addKey(actions, QStringLiteral("←"), QStringLiteral("Move left"));
    addKey(actions, QStringLiteral("→"), QStringLiteral("Move right"));
    addKey(actions, QStringLiteral("Prev"), QStringLiteral("Older command"));
    addKey(actions, QStringLiteral("Next"), QStringLiteral("Newer command"));
    addKey(actions, QStringLiteral("Hist"), QStringLiteral("Command history"));
    addKey(actions, QStringLiteral("BS"), QStringLiteral("Backspace"));
    addKey(actions, QStringLiteral("Enter"), QStringLiteral("Submit the console line, or a newline in the editor"));
    addKey(actions, QStringLiteral("Space"), QStringLiteral("Space"));
    addKey(actions, QStringLiteral("Tab"), QStringLiteral("Tab"));
    addKey(actions, QStringLiteral("Esc"), QStringLiteral("Escape. Quits the graphics window when it is open."));
    m_ctrl = new QPushButton(QStringLiteral("Ctrl"), actions);
    m_ctrl->setCheckable(true);
    m_ctrl->setFocusPolicy(Qt::NoFocus);
    m_ctrl->setToolTip(QStringLiteral("Next symbol is a control character"));
    m_ctrl->setMinimumHeight(36);
    actionRow->addWidget(m_ctrl);
    connect(m_ctrl, &QPushButton::clicked, this, &InputBar::toggleControl);
    addKey(actions, QStringLiteral("Copy"), QStringLiteral("Copy"));
    addKey(actions, QStringLiteral("Paste"), QStringLiteral("Paste"));
    addKey(actions, QStringLiteral("Find"), QStringLiteral("Find"));
    addKey(actions, QStringLiteral("Split"), QStringLiteral("Split editor"));
    addKey(actions, QStringLiteral("View"), QStringLiteral("View click"));
    actionRow->addStretch(1);
    symbolRow->addStretch(1);

    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(0, 0, 0, 0);
    box->setSpacing(0);
    box->addWidget(scroller(symbols, this));
    box->addWidget(scroller(actions, this));
}

void InputBar::addKey(QWidget *row, const QString &label, const QString &tip, int width)
{
    auto *button = new QPushButton(label, row);
    button->setFocusPolicy(Qt::NoFocus);
    button->setToolTip(tip);
    button->setMinimumHeight(36);
    if (width > 0)
        button->setFixedWidth(width);
    row->layout()->addWidget(button);
    connect(button, &QPushButton::clicked, this, [this, label] {
        if (label == QLatin1String("←"))
            emit arrowPressed(Qt::Key_Left);
        else if (label == QLatin1String("→"))
            emit arrowPressed(Qt::Key_Right);
        else if (label == QLatin1String("Prev"))
            emit historyOlder();
        else if (label == QLatin1String("Next"))
            emit historyNewer();
        else if (label == QLatin1String("Hist"))
            emit historyMenu();
        else if (label == QLatin1String("BS"))
            emit backspacePressed();
        else if (label == QLatin1String("Enter"))
            emit enterPressed();
        else if (label == QLatin1String("Space"))
            emit insertText(QStringLiteral(" "));
        else if (label == QLatin1String("Tab"))
            emit tabPressed();
        else if (label == QLatin1String("Esc"))
            emit escapePressed();
        else if (label == QLatin1String("Copy"))
            emit copyPressed();
        else if (label == QLatin1String("Paste"))
            emit pastePressed();
        else if (label == QLatin1String("Find"))
            emit findPressed();
        else if (label == QLatin1String("Split"))
            emit splitPressed();
        else if (label == QLatin1String("View"))
            emit viewPressed();
        else if (m_control && label.size() == 1 && label.at(0).isLetter()) {
            const int code = label.at(0).toUpper().unicode() - 'A' + 1;
            emit insertText(QString(QChar(code)));
            m_control = false;
            if (m_ctrl != nullptr)
                m_ctrl->setChecked(false);
        } else if (label.size() > 1 && label != QLatin1String("\\")) {
            emit insertText(label + QLatin1Char(' '));
        } else {
            emit insertText(label);
        }
    });
}

void InputBar::toggleControl()
{
    m_control = m_ctrl != nullptr && m_ctrl->isChecked();
}
