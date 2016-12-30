#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick/QQuickView>
#include "source/BluetoothSerial.h"
#include "source/Platform.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<BluetoothSerial>("bluetoothSerial.lib", 1, 0, "BluetoothSerial");
    qmlRegisterType<Platform>("stewart.lib", 1, 1, "Stewart");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
