﻿import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import bluetoothSerial.lib 1.0
import QtQuick.Layouts 1.3

//蓝牙界面
Item {
    id: page    //对于外部想要访问的数据或功能，只能通过property和信号signal或者函数function可以交互
    property alias receivedText: receivedText       //属性别名
    property alias bluetoothSerialPort: bluetoothSerialPort
    property alias isConnected: bluetoothSerialPort.connected
    function send(data) {
        receivedText.append(data);
        bluetoothSerialPort.send(data);
    }
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        //接收内容
        GroupBox {
            title: "接收数据"
            Layout.fillHeight: true                                             //该语句可以实现该控件在高度上的自动调整，铺满窗口
            Layout.fillWidth: true
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
                    bluetoothSerialPort.connectToDevice(index)
                }
            }
        }

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
                    bluetoothSerialPort.send(sendText.text)
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
                    bluetoothSerialPort.scan()
                    bluetoothList.clear()
                }
            }
            Button {
                id: disConnect
                text: qsTr("断开")
                onClicked:  {
                    bluetoothSerialPort.disconnect()
                }
            }
        }
    }

    BluetoothSerial {
        id: bluetoothSerialPort
    }

    //添加蓝牙设备
    Connections {
        target: bluetoothSerialPort
        onAddDevice: {
            bluetoothList.append({"text": info})
        }
    }
    //打印调试信息
    Connections {
        target: bluetoothSerialPort
        onConsoleInfo:{
            receivedText.append(info)
        }
    }
}
