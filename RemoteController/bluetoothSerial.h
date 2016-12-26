#ifndef BLUETOOTHSERIAL_H
#define BLUETOOTHSERIAL_H
#include <QtBluetooth/qbluetoothglobal.h>
#include <QtBluetooth/qbluetoothlocaldevice.h>
#include <qbluetoothaddress.h>
#include <qbluetoothdevicediscoveryagent.h>
#include <qbluetoothlocaldevice.h>
#include <qbluetoothsocket.h>

class bluetoothSerial : public QObject
{
    Q_OBJECT
public:
    bluetoothSerial();
    ~bluetoothSerial();


signals:
    void addDevice(QString info);
    void consoleInfo(QString info);

public slots:
    void scan();
    void read();
    void send(QString data);
    void disconnect();
    void addBlueToothDevicesToList(const QBluetoothDeviceInfo&);
    void connectToDevice(int index);
    void bluetoothConnectedEvent();
    void bluetoothDisconnectedEvent();
    void finishScan();

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QBluetoothLocalDevice *localDevice;
    QBluetoothSocket *socket;
    QList<QBluetoothDeviceInfo> bluetoothDeviceInfoList;
    unsigned char comBuffer[15];
    unsigned int  comCount;
    QString comStr;
};

#endif // BLUETOOTHSERIAL_H
