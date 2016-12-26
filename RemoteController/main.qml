import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import "content"

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    id: root

    //姿态识别模块
    Loader {
        id: viewPose
        visible: false
        anchors.bottom: control.top
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 5
        source: "content/accel.qml"
    }
    //蓝牙模块
    Loader {
        id: viewBluetooth
        visible: true
        anchors.bottom: control.top
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 5
        source: "content/myBluetooth.qml"
    }

    ToolBar {
        id: control
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Row{
            //向导
            ToolButton {
                id: buttonBluetooth
                text: qsTr("蓝牙")
                onClicked: {
                    viewBluetooth.visible = true
                    viewPose.visible = false
                }
            }
            ToolButton {
                id: buttonPose
                text:qsTr("陀螺仪")
                onClicked: {
                    viewBluetooth.visible = false
                    viewPose.visible = true
//                    buttonBluetooth.highlighted = false
//                    buttonPose.highlighted = true
                }
            }
        }
    }
}
