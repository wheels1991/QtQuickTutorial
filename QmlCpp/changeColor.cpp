#include "changeColor.h"
#include <QDateTime>
#include <QColor>
#include <QVariant>

ChangeQmlColor::ChangeQmlColor(QObject *target, QObject *parent)
    : QObject(parent)
    , m_timer(this)
{
    qsrand(QDateTime::currentDateTime().toTime_t());
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    m_timer.start(1000);

    m_target = target->findChild<QObject *>("rootRect");
}

ChangeQmlColor::~ChangeQmlColor()
{}

void ChangeQmlColor::onTimeout()
{
    QColor color = QColor::fromRgb(qrand()%256, qrand()%256, qrand()%256);
    m_target->setProperty("color", color);
}
