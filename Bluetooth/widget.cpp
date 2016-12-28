#include "widget.h"
#include "ui_widget.h"
#include "QMessageBox"

static const QLatin1String serviceUuid("00001101-0000-1000-8000-00805F9B34FB");

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    localDevice = new QBluetoothLocalDevice();
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);

    connect(discoveryAgent,
            SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this,
            SLOT(addBlueToothDevicesToList(QBluetoothDeviceInfo))
            );
    connect(ui->list,
            SIGNAL(itemActivated(QListWidgetItem*)),
            this,
            SLOT(itemActivated(QListWidgetItem*))
            );
    connect(socket,
            SIGNAL(readyRead()),
            this,
            SLOT(readBluetoothDataEvent())
            );
    connect(socket,
            SIGNAL(connected()),
            this,
            SLOT(bluetoothConnectedEvent())
            );
    connect(socket,
            SIGNAL(disconnected()),
            this,
            SLOT(bluetoothDisconnectedEvent())
            );

    if( localDevice->hostMode() == QBluetoothLocalDevice::HostPoweredOff ) {
        ui->pushButton_openBluetooth->setEnabled(true);
        ui->pushButton_closeDevice->setEnabled(false);
    }else {
        ui->pushButton_openBluetooth->setEnabled(false);
        ui->pushButton_closeDevice->setEnabled(true);
    }

    if( localDevice->hostMode() == QBluetoothLocalDevice::HostDiscoverable ) {
        ui->checkBox_discoverable->setChecked(true);
    }else {
        ui->checkBox_discoverable->setChecked(false);
    }
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_pushButton_scan_clicked()
{

    discoveryAgent->start();
    ui->pushButton_scan->setEnabled(false);

}

void Widget::addBlueToothDevicesToList( const QBluetoothDeviceInfo &info )
{
    QString label = QString("%1 %2").arg(info.address().toString()).arg(info.name());

    QList<QListWidgetItem *> items = ui->list->findItems(label, Qt::MatchExactly);

    if (items.empty()) {
        QListWidgetItem *item = new QListWidgetItem(label);
        QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(info.address());
        if (pairingStatus == QBluetoothLocalDevice::Paired || pairingStatus == QBluetoothLocalDevice::AuthorizedPaired )
            item->setTextColor(QColor(Qt::green));
        else
            item->setTextColor(QColor(Qt::black));
        ui->list->addItem(item);
    }

}


void Widget::on_pushButton_openBluetooth_clicked()
{
    localDevice->powerOn();
    ui->pushButton_closeDevice->setEnabled(true);
    ui->pushButton_openBluetooth->setEnabled(false);
    ui->pushButton_scan->setEnabled(true);
}


void Widget::on_pushButton_closeDevice_clicked()
{
    localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);
    ui->pushButton_closeDevice->setEnabled(false);
    ui->pushButton_openBluetooth->setEnabled(true);
    ui->pushButton_scan->setEnabled(false);
}

void Widget::itemActivated(QListWidgetItem *item)
{
    QString text = item->text();

    int index = text.indexOf(' ');

    if (index == -1)
        return;

    QBluetoothAddress address(text.left(index));
    QString name(text.mid(index + 1));
    qDebug() << "You has choice the bluetooth address is " << address;
    qDebug() << "The device is connneting.... ";
    QMessageBox::information(this,tr("Info"),tr("The device is connecting..."));
    socket->connectToService(address, QBluetoothUuid(serviceUuid) ,QIODevice::ReadWrite);

}


void Widget::readBluetoothDataEvent()
{

    QByteArray line = socket->readAll();
    QString strData = QString::fromStdString(line.toStdString());
//    QString strData = line.toHex();
    comStr.append(strData);
    qDebug() <<"rec data is: "<< comStr;
    qDebug() <<"The comStr length is: " << comStr.length();
    if(comStr.length() >= 0) {

        ui->textBrowser_info->append(comStr);
        comStr.clear();
    }

}

void Widget::bluetoothConnectedEvent()
{
    qDebug() << "The android device has been connected successfully!";
    QMessageBox::information(this,tr("Info"),tr("successful connection!"));
}

void Widget::bluetoothDisconnectedEvent()
{
    qDebug() << "The android device has been disconnected successfully!";
    QMessageBox::information(this,tr("Info"),tr("successful disconnection!"));
}

void Widget::on_pushButton_disconnect_clicked()
{
    socket->disconnectFromService();

}

void Widget::on_pushButton_send_clicked()
{
    QByteArray arrayData;
    QString s("Hello Windows!!!\nThis message is sended via bluetooth of android device!\n");
    arrayData = s.toUtf8();
    socket->write(arrayData);
}

void Widget::on_pushButton_clear_clicked()
{
    ui->textBrowser_info->clear();
}
