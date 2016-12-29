import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1

import "content"

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    id: root

    TabView {
        anchors.fill: parent
        style: touchStyle
        tabPosition: Qt.BottomEdge
        Tab {
            title: "蓝牙"
            id: tabBluetooth
            sourceComponent: MyBluetooth {}
        }
        Tab {
            title: "陀螺仪"
            id:tabPoseSensor
            sourceComponent: PoseSensor {}
        }
    }
//以下方法无法通过Tab中声明的对象的ID进行访问
//    TabView {
//        anchors.fill: parent
//        style: touchStyle
//        tabPosition: Qt.BottomEdge
//        Tab {
//            title: "蓝牙"
//            MyBluetooth {
//                id: pageBluetooth
//            }
//        }
//        Tab {
//            title: "陀螺仪"
//            PoseSensor {
//                id: pagePoseSensor
//            }
//        }
//    }

    Timer {
        interval: 1000
        repeat: true
        running: true//tabBluetooth.item.bluetoothSerialPort.isConnected
        onTriggered: {
            tabBluetooth.item.receivedText.append("\nisConnected: " + tabBluetooth.item.isConnected)
            tabBluetooth.item.receivedText.append("Roll: " + tabPoseSensor.item.roll)
            tabBluetooth.item.receivedText.append("Pitch: " + tabPoseSensor.item.pitch)
        }
    }

    Component {
        id: touchStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item { }
            tab: Item {
                implicitWidth: control.width/control.count
                implicitHeight: (control.width > control.height ? control.height : control.width)/control.count / 4
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "image/tab_selected.png":"../image/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: styleData.title.toUpperCase()
                        font.pixelSize: (control.width > control.height ? control.height : control.width)/control.count / 8
                    }
                    Rectangle {
                        visible: index > 0
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        width:1
                        color: "#3a3a3a"
                    }
                }
            }
        }
    }

}
