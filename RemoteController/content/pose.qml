import QtQuick 2.0
import QtSensors 5.3
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4

import "../image"

//陀螺仪界面
Item {
    id: viewPose
    CircularGauge {
        value: accel.roll
        maximumValue: 90
        minimumValue: -90
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        width: (parent.width > parent.height ? parent.height : parent.width) / 2
        height: width
        Text {
            text: "横滚角"
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.6
            color: "Black"
        }
        Behavior on value {
            NumberAnimation {
                duration: 100
            }
        }
    }
    CircularGauge {
        value: accel.pitch
        maximumValue: 90
        minimumValue: -90
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        width: (parent.width > parent.height ? parent.height : parent.width) / 2
        height: width
        Text {
            text: "俯仰角"
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.6
            color: "Black"
        }
        Behavior on value {
            NumberAnimation {
                duration: 100
            }
        }
    }

    Accelerometer {
        id: accel
        dataRate: 100
        active:true
        signal poseChanged(double r, double p)
        property double roll
        property double pitch
        onReadingChanged: {
            roll = calcRoll(accel.reading.x, accel.reading.y, accel.reading.z)
            pitch = calcPitch(accel.reading.x, accel.reading.y, accel.reading.z)
            accel.poseChanged(roll, pitch)
        }
        function calcPitch(x,y,z) {
            return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795);
        }
        function calcRoll(x,y,z) {
             return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795);
        }
    }
}
