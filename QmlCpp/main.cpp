#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick/QQuickView>
#include <QDebug>
#include "changeColor.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QList<QObject *> localRootObjects = engine.rootObjects();
    qDebug() << "Objects size: " << localRootObjects.size();
    QObject * const rootItem = localRootObjects.first();

    ChangeQmlColor item(rootItem);
    QObject * quitButton = rootItem->findChild<QObject*>("quitButton");
    if (quitButton) {
        QObject::connect(quitButton, SIGNAL(clicked()), &app, SLOT(quit()));
    }
    QObject *textLabel = rootItem->findChild<QObject *>("textLabel");
    if (textLabel) {
        bool bRet = QMetaObject::invokeMethod(textLabel, "setText", Q_ARG(QString, "world hello"));
        qDebug() << "call setText return - " << bRet;
        textLabel->setProperty("color", QColor::fromRgb(255,0,0));
        textLabel->setProperty("text", QString("Hello"));
        bRet = QMetaObject::invokeMethod(textLabel, "doLayout");
        qDebug() << "call doLayout return - " << bRet;
    }
    return app.exec();
}
