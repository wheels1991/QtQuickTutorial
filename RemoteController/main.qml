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
        currentIndex: 1
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
            tabBluetooth.item.receivedText.append("isConnected: " + tabBluetooth.item.isConnected);
            tabBluetooth.item.receivedText.append("Roll: " + tabPoseSensor.item.roll +
                                                 " Pitch: " + tabPoseSensor.item.pitch);
            tabBluetooth.item.receivedText.append("Px: " + tabStewart.item.px +
                                                 " Py: " + tabStewart.item.py +
                                                 " Pz: " + tabStewart.item.pz +
                                                 " Pa: " + tabStewart.item.pa +
                                                 " Pb: " + tabStewart.item.pb +
                                                 " Pc: " + tabStewart.item.pc);
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
                implicitHeight: (control.width > control.height ? control.height : control.width)/ 8
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "image/tab_selected.png":"../image/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: styleData.title.toUpperCase()
                        font.pixelSize: (control.width > control.height ? control.height : control.width)/ 16
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
