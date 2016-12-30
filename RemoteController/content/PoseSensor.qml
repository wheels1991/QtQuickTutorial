import QtQuick 2.0
import QtSensors 5.3
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import stewart.lib 1.1

//陀螺仪界面
Item {
    id: page
    //对于外部想要访问的数据或功能，只能通过property和信号signal或者函数function可以交互
    property double roll
    property double pitch
    signal poseChanged(double r, double p)

    property double poseZ: 278
    property double joint0: 0
    property double joint1: 0
    property double joint2: 0
    property double joint3: 0
    property double joint4: 0
    property double joint5: 0
    signal jointsChanged(double j0, double j1, double j2,
                         double j3, double j4, double j5)
    Stewart {
        id: stewart
    }

    CircularGauge {
        value: page.roll
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
        value: page.pitch
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
        onReadingChanged: {
            roll = (calcRoll(accel.reading.x, accel.reading.y, accel.reading.z)).toFixed(2)    //toFixed(2)控制小数位置
            pitch = (calcPitch(accel.reading.x, accel.reading.y, accel.reading.z)).toFixed(2)
            poseChanged(roll, pitch);
            stewart.SetPos(0, 0, poseZ, roll, pitch, 0);
        }
        function calcPitch(x,y,z) {
            return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795);
        }
        function calcRoll(x,y,z) {
             return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795);
        }
    }
    Connections {
        target: stewart
        onJointsChanged: {
            joint0 = (j0).toFixed(2);
            joint1 = (j1).toFixed(2);
            joint2 = (j2).toFixed(2);
            joint3 = (j3).toFixed(2);
            joint4 = (j4).toFixed(2);
            joint5 = (j5).toFixed(2);
        }
    }
}
