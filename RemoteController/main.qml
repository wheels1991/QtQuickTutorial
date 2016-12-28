﻿import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1

import "content" as Content

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
            source: "content/myBluetooth.qml"
        }
        Tab {
            title: "陀螺仪"
            source: "content/accel.qml"
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
                implicitHeight: 40
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "image/tab_selected.png":"../image/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        text: styleData.title.toUpperCase()
                        font.pixelSize: 20
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
