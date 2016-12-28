﻿import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import an.qt.bluetoothSerial 1.0
import QtQuick.Layouts 1.3

//蓝牙界面
Item {
    id: viewBluetooth
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        //接收内容
        GroupBox {
            title: "接收数据"
            Layout.fillHeight: true
            Layout.fillWidth: true
            height: viewBluetooth.height / 3
            TextArea {
                anchors.fill: parent
                id: receivedText
                text: qsTr("This is received data")
            }
        }
        //发送内容
        GroupBox {
            title: "发送数据"
            Layout.fillWidth: true
            TextField {
                anchors.fill: parent
                id: sendText
                text: qsTr("This is to send")
            }
        }
        //组织蓝牙设备列表
        GroupBox{
            title: "蓝牙列表"
            Layout.fillWidth: true
            ComboBox {
                id: bluetoothComboBox
                anchors.fill: parent
                model: ListModel {
                    id: bluetoothList
        //            ListElement { text: "Banana" }
                }
                onActivated: {
                    myBluetoothSerial.connectToDevice(index)
                }
            }
        }
//        Item { Layout.fillHeight: true }

        //蓝牙相关按键
        RowLayout {
            Layout.fillWidth: true

            id: rowLayout
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (parent.width - 4 * send.width) / 3
            Button {
                id: send
                text: qsTr("发送")
                onClicked: {
                    receivedText.append(sendText.text)
                    myBluetoothSerial.send(sendText.text)
                }
            }
            Button {
                id: clear
                text: qsTr("清空")
                onClicked: {
                    receivedText.text = ""
                    sendText.text = ""
                }
            }
            Button {
                id:scan
                text: qsTr("扫描")
                onClicked: {
                    myBluetoothSerial.scan()
                    bluetoothList.clear()
                }
            }
            Button {
                id: disConnect
                text: qsTr("断开")
                onClicked:  {
                    myBluetoothSerial.disconnect()
                }
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: myBluetoothSerial.connected()
        onTriggered: {
            receivedText.append("Timer test");
//            receivedText.append(viewPose.accel.roll);
        }

    }

    BluetoothSerial {
        id: myBluetoothSerial
    }

    //添加蓝牙设备
    Connections {
        target: myBluetoothSerial
        onAddDevice: {
            bluetoothList.append({"text": info})
        }
    }
    //打印调试信息
    Connections {
        target: myBluetoothSerial
        onConsoleInfo:{
            receivedText.append(info)
        }
    }
}
