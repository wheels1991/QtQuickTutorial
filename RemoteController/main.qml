import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import stewart.lib 1.1

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
            title: qsTr("蓝牙")
            id: tabBluetooth
            focus: true
            sourceComponent: MyBluetooth {}
        }
        Tab {
            title: qsTr("陀螺仪")
            id:tabPoseSensor
            sourceComponent: PoseSensor {}
        }
        Tab {
            title: qsTr("平台")
            id:tabStewart
            sourceComponent: StewartController {}
        }
        Tab {
            title: qsTr("设置")
            id: tabSetup
            sourceComponent: Setup {}
        }
    }

    //进行数据的计算
    Timer {
        interval: 1000 / tabBluetooth.item.frequency
        repeat: true
        running: true//tabBluetooth.item.bluetoothSerialPort.isConnected
        onTriggered: {
            if (tabPoseSensor.item.isEnable) {
                console.log("Into tabPose sensor")
                stewart.setPos(0, 0, tabSetup.item.zCentralPos,
                               tabPoseSensor.item.roll / 5,
                               tabPoseSensor.item.pitch / 5, 0);
            } else if (tabStewart.item.isEnable) {
                stewart.setPos(tabStewart.item.px,
                               tabStewart.item.py,
                               tabStewart.item.pz,
                               tabStewart.item.pa,
                               tabStewart.item.pb,
                               tabStewart.item.pc);
            }
        }
    }
    //处理平台尺寸参数的变化
    Connections {
        target: tabSetup.item
        onParasChanged:{
            stewart.setParas(tR, tI, bR, bI, aL, cH, lL, xyz, abc, zPos, type);
            tabStewart.item.xyzRange = xyz;
            tabStewart.item.abcRange = abc
            tabStewart.item.zCentralPos= zPos;

        }
    }
    //处理平台解算后的数据，将其通过蓝牙进行发送
    Connections {
        target: stewart
        onJointsChanged: {
            tabBluetooth.item.send("S#" + (j0).toFixed(2) +
                                    "#" + (j1).toFixed(2) +
                                    "#" + (j2).toFixed(2) +
                                    "#" + (j3).toFixed(2) +
                                    "#" + (j4).toFixed(2) +
                                    "#" + (j5).toFixed(2));
        }
    }

    Stewart {
        id: stewart
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
