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
        style: tableStyle
        tabPosition: Qt.BottomEdge
        currentIndex: 1
        Tab {
            title: "蓝牙"
            id: tabBluetooth
            focus: true
            sourceComponent: MyBluetooth {}
        }
        Tab {
            title: "陀螺仪"
            id:tabPoseSensor
            sourceComponent: PoseSensor {}
        }
        Tab {
            title: "平台"
            id:tabStewart
            sourceComponent: StewartController {}
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true//tabBluetooth.item.bluetoothSerialPort.isConnected
        onTriggered: {
//            tabBluetooth.item.receivedText.append("Roll: " + tabPoseSensor.item.roll +
//                                                 " Pitch: " + tabPoseSensor.item.pitch);
            if (tabPoseSensor.item.isEnable) {
                tabBluetooth.item.receivedText.append("S#" + tabPoseSensor.item.joint0 +
                                                       "#" + tabPoseSensor.item.joint1 +
                                                       "#" + tabPoseSensor.item.joint2 +
                                                       "#" + tabPoseSensor.item.joint3 +
                                                       "#" + tabPoseSensor.item.joint4 +
                                                       "#" + tabPoseSensor.item.joint5 + "#E");
            } else if (tabStewart.item.isEnable) {
                tabBluetooth.item.receivedText.append("S#" + tabStewart.item.joint0 +
                                                       "#" + tabStewart.item.joint1 +
                                                       "#" + tabStewart.item.joint2 +
                                                       "#" + tabStewart.item.joint3 +
                                                       "#" + tabStewart.item.joint4 +
                                                       "#" + tabStewart.item.joint5 + "#E");
            }
        }
    }

    //TabView的style
    Component {
        id: tableStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item { }
            tab: Rectangle {
                implicitHeight: (control.width > control.height ? control.height : control.width)/ 8
                implicitWidth: control.width/control.count
                color: styleData.selected ? "lightsteelblue" :"steelblue"
                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "black" : "white"
                    font.pixelSize: (control.width > control.height ? control.height : control.width)/ 16
                }
            }
        }
    }

}
