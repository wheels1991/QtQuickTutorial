#include "bluetoothSerial.h"
#include <QMessageBox>

static const QLatin1String serviceUuid("00001101-0000-1000-8000-00805F9B34FB");

bluetoothSerial::bluetoothSerial()
{
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    localDevice = new QBluetoothLocalDevice();
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
            this, &bluetoothSerial::addBlueToothDevicesToList);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &bluetoothSerial::finishScan);
    connect(socket, &QIODevice::readyRead, this, &bluetoothSerial::read);
    connect(socket, &QBluetoothSocket::connected, this, &bluetoothSerial::bluetoothConnectedEvent);
    connect(socket, &QBluetoothSocket::disconnected, this, &bluetoothSerial::bluetoothDisconnectedEvent);
}

bluetoothSerial::~bluetoothSerial()
{

}

void bluetoothSerial::scan()
{
    bluetoothDeviceInfoList.clear();
    discoveryAgent->start();
    qDebug() << "Scan bluetooth device";
}

void bluetoothSerial::read()
{
    QByteArray line = socket->readAll();
    QString strData = QString::fromStdString(line.toStdString());
//    QString strData = line.toHex();
    comStr.append(strData);
    qDebug() <<"rec data is: "<< comStr;
    qDebug() <<"The comStr length is: " << comStr.length();
    if(comStr.length() >= 0) {

        comStr.clear();
    }
}

void bluetoothSerial::send(QString data)
{
//    Q_UNUSED(data);
    qDebug() << "Send data by bluetooth device";
    QByteArray arrayData;
    QString s("Hello Windows!!!\nThis message is sended via bluetooth of android device!\n");
    arrayData = s.toUtf8();
//    socket->write(arrayData);
    socket->write(data.toUtf8());
}

void bluetoothSerial::disconnect()
{
    socket->disconnectFromService();
}

void bluetoothSerial::addBlueToothDevicesToList(const QBluetoothDeviceInfo &info)
{
    bluetoothDeviceInfoList.append(info);
    QString label = QString("%1 %2").arg(info.address().toString()).arg(info.name());
    qDebug() << "New divece: " << label;
    emit addDevice(label);
    emit consoleInfo(QString("Find a new device %1").arg(label));
}

void bluetoothSerial::connectToDevice(int index)
{
    qDebug() << "Connect to device: " << index;
    emit consoleInfo(QString("Connect to device %1").arg(index));
    if (index == -1)
        return;
    QBluetoothDeviceInfo info = bluetoothDeviceInfoList[index];
//    QMessageBox::information(this,tr("Info"),tr("The device is connecting..."));
    socket->connectToService(info.address(), QBluetoothUuid(serviceUuid) ,QIODevice::ReadWrite);
}

void bluetoothSerial::bluetoothConnectedEvent()
{
    emit consoleInfo("Succeed to connect");
//    QMessageBox::information(this,tr("Info"),tr("successful connection!"));
}

void bluetoothSerial::bluetoothDisconnectedEvent()
{
    emit consoleInfo("Succeed to disconnect");
    //    QMessageBox::information(this,tr("Info"),tr("successful disconnection!"));
}

void bluetoothSerial::finishScan()
{
    emit consoleInfo("Finish scan");
}
