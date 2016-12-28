import QtQuick 2.0
import QtSensors 5.3
import QtQuick.Controls 1.4

import "../image"

//陀螺仪界面
Item {
    id: viewPose
    Rectangle {
        anchors.fill: parent
        color: "white"
    }
    GroupBox {
        title: "姿态"
        anchors.top: parent.top
        width: parent.width
        height: 5 * rollText.height + 10
        Column {
            id: position
            anchors.left: parent.left
            anchors.top: parent.top
            spacing: 10
            Text {
                id: rollText
                text: qsTr("Roll: ")
            }
            Text {
                id: pitchText
                text: qsTr("Pitch: ")
            }
        }
    }


    Accelerometer {
        id: accel
        dataRate: 100
        active:true
        signal poseChanged(double r, double p)
        onReadingChanged: {
            var roll = calcRoll(accel.reading.x, accel.reading.y, accel.reading.z)
            var pitch = calcPitch(accel.reading.x, accel.reading.y, accel.reading.z)
            accel.poseChanged(roll, pitch)
            bubble.x = parent.width / 2 + parent.width / 180 * roll
            bubble.y = parent.height / 2 - parent.height / 180 * pitch
        }
        function calcPitch(x,y,z) {
            return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795);
        }
        function calcRoll(x,y,z) {
             return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795);
        }
    }
    Connections {
        target: accel
        onPoseChanged: {
            rollText.text = qsTr("Roll: ") + r.toFixed(2);
            pitchText.text = qsTr("Pitch: ") + p.toFixed(2);
        }
    }

    Image {
        id: bubble
        source: "../image/bubble.jpg"
        smooth: true
        property real centerX: parent.width / 2
        property real centerY: parent.height / 2
        property real bubbleCenter: bubble.width / 2
        x: centerX - bubbleCenter
        y: centerY - bubbleCenter

        Behavior on y {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
        Behavior on x {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
    }
}
