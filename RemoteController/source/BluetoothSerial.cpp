#include "BluetoothSerial.h"
#include <QMessageBox>

static const QLatin1String serviceUuid("00001101-0000-1000-8000-00805F9B34FB");

BluetoothSerial::BluetoothSerial()
{
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    localDevice = new QBluetoothLocalDevice();
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
            this, &BluetoothSerial::addBlueToothDevicesToList);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &BluetoothSerial::finishScan);
    connect(socket, &QIODevice::readyRead, this, &BluetoothSerial::read);
    connect(socket, &QBluetoothSocket::connected, this, &BluetoothSerial::bluetoothConnectedEvent);
    connect(socket, &QBluetoothSocket::disconnected, this, &BluetoothSerial::bluetoothDisconnectedEvent);
}

BluetoothSerial::~BluetoothSerial()
{

}

void BluetoothSerial::scan()
{
    bluetoothDeviceInfoList.clear();
    discoveryAgent->start();
    emit consoleInfo("Start scan");
    qDebug() << "Scan bluetooth device";
}

void BluetoothSerial::read()
{
    QByteArray line = socket->readAll();
    QString stringData = QString::fromStdString(line.toStdString());
//    QString strData = line.toHex();
    qDebug() <<"Received data is: "<< stringData;
    qDebug() <<"Received data's length is: " << stringData.length();
    if(stringData.length() >= 0) {
        stringData.clear();
    }
}

void BluetoothSerial::send(QString data)
{
//    Q_UNUSED(data);
    qDebug() << "Send data by bluetooth device";
//    QByteArray arrayData;
//    QString s("Hello Windows!!!\nThis message is sended via bluetooth of android device!\n");
//    arrayData = s.toUtf8();
//    socket->write(arrayData);
    qDebug() << "Data in QByteArray: " << data.toUtf8();
    QByteArray utf8 = data.toUtf8();
    socket->write(data.toUtf8());
}

void BluetoothSerial::disconnect()
{
    socket->disconnectFromService();
    isConnected = false;
}

void BluetoothSerial::addBlueToothDevicesToList(const QBluetoothDeviceInfo &info)
{
    bluetoothDeviceInfoList.append(info);
    QString label = QString("%1 %2").arg(info.address().toString()).arg(info.name());
    qDebug() << "New divece: " << label;
    emit addDevice(label);
    emit consoleInfo(QString("Find a new device %1").arg(label));
}

void BluetoothSerial::connectToDevice(int index)
{
    qDebug() << "Connect to device: " << index;
    emit consoleInfo(QString("Connect to device %1").arg(index));
    if (index == -1)
        return;
    QBluetoothDeviceInfo info = bluetoothDeviceInfoList[index];
//    QMessageBox::information(this,tr("Info"),tr("The device is connecting..."));
    socket->connectToService(info.address(), QBluetoothUuid(serviceUuid) ,QIODevice::ReadWrite);
    isConnected = true;
}

void BluetoothSerial::bluetoothConnectedEvent()
{
    emit consoleInfo("Succeed to connect");
//    QMessageBox::information(this,tr("Info"),tr("successful connection!"));
}

void BluetoothSerial::bluetoothDisconnectedEvent()
{
    emit consoleInfo("Succeed to disconnect");
    //    QMessageBox::information(this,tr("Info"),tr("successful disconnection!"));
}

void BluetoothSerial::finishScan()
{
    emit consoleInfo("Finish scan");
}
