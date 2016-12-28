#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "ColorMaker.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<ColorMaker>("an.qt.ColorMaker", 1, 0, "ColorMaker");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
