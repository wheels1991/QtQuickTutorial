import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import an.qt.bluetoothSerial 1.0

//蓝牙界面
Item {
    id: viewBluetooth
    //接收内容
    Label {
        id: labelReceive
        color: "red"
        text: qsTr("接收数据：")
        anchors.top: parent.top
        anchors.left: parent.left
    }

    TextArea {
        id: receivedText
        width: parent.width
        height: mainWindow.height / 4
        anchors.top: labelReceive.bottom
        anchors.left: parent.left
        text: qsTr("This is received data")
    }
    //发送内容
    Label {
        id: labelSend
        color: "red"
        text:qsTr("发送数据：")
        anchors.top: receivedText.bottom
        anchors.left: parent.left
    }
    TextEdit {
        id: sendText
        width: parent.width
        height: mainWindow.height / 10

        anchors.top: labelSend.bottom
        anchors.left: parent.left
        text: qsTr("This is to send")
    }


    //组织蓝牙设备列表
    Label {
        id: labelBluetoothList
        text:qsTr("蓝牙列表：")
        color: "red"
        anchors.top: sendText.bottom
        anchors.left: parent.left
    }

    ComboBox {
        id: bluetoothComboBox
        anchors.top: labelBluetoothList.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 2
        model: ListModel {
            id: bluetoothList
//            ListElement { text: "Banana" }
        }
        width: parent.width
        onActivated: {
            myBluetoothSerial.connectToDevice(index)
        }
    }
    //蓝牙相关按键
    Row {
        id: rowLayout
        anchors.bottom: parent.bottom
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
