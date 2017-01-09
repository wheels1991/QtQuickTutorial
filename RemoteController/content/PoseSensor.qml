import QtQuick 2.0
import QtSensors 5.3
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

//陀螺仪界面
Item {
    id: page
    //对于外部想要访问的数据或功能，只能通过property和信号signal或者函数function可以交互
    property double roll: 0
    property double pitch: 0
    property double yaw: 0
    property double yaw0: 0
    property bool isEnable: checkBox.checked
    signal poseChanged(double r, double p, double y)

    CircularGauge {
        id: rollCircularGauge
        value: page.roll
        maximumValue: 90
        minimumValue: -90
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: pitchCircularGauge.top
//            anchors.bottomMargin: 20
        width: (parent.width > parent.height ? parent.height : parent.width) *0.5
        height: width
        style: circularGaugeStyle
        Text {
            text: qsTr("横滚角")
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
        id: pitchCircularGauge
        value: page.pitch
        maximumValue: 90
        minimumValue: -90
        anchors.centerIn: parent
        width: (parent.width > parent.height ? parent.height : parent.width) *0.5
        height: width
        style: circularGaugeStyle
        Text {
            text: qsTr("俯仰角")
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
        id: yawCircularGauge
        value: page.yaw
        maximumValue: 90
        minimumValue: -90
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pitchCircularGauge.bottom
//            anchors.topMargin: 20
        width: (parent.width > parent.height ? parent.height : parent.width) *0.5
        height: width
        style: circularGaugeStyle
        Text {
            text: qsTr("偏航角")
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
    Row {
        width: parent.width
        anchors.bottom: checkBox.top
        anchors.bottomMargin: 10
        height: checkBox.height
        Label {
            id: label
            width: parent.width * 0.3
            text: qsTr("基准偏航角 ")
        }
        Slider {
            id: slider
            width: parent.width * 0.7
            stepSize: 0.5
            value: 0
            minimumValue: -180
            maximumValue: 180
            onValueChanged: {
                page.yaw0 = value
                label.text = qsTr("基准偏航角 ") + value
            }
        }
    }
    CheckBox {
        id: checkBox
        anchors.bottom: parent.bottom
        anchors.bottomMargin: page.height / 20
        anchors.left: parent.left
        checked: false
        style: CheckBoxStyle {
            indicator: Rectangle {
                implicitWidth: page.width / 20
                implicitHeight:implicitWidth
                radius: 3
                color: control.checked ? "steelblue" : "white"
                border.color: "black"
            }
            label: Text {
                text: qsTr("控制使能")
                font.pixelSize: page.width / 20
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
            roll = (roll > 20 ? 20 : roll) < -20 ? -20 : (roll > 20 ? 20 : roll)
            pitch = (pitch > 20 ? 20 : pitch) < -20 ? -20 : (pitch > 20 ? 20 : pitch)
            if (checkBox.checked) {
                poseChanged(roll, pitch, yaw)
            }
        }
        function calcPitch(x,y,z) {
            return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795)
        }
        function calcRoll(x,y,z) {
             return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795)
        }
    }
    Compass {
        id: compass
        active: true
        dataRate: 100
        onReadingChanged: {
            yaw = reading.azimuth - yaw0
            yaw = (yaw > 20 ? 20 : yaw) < -20 ? -20 : (yaw > 20 ? 20 : yaw)
            if (checkBox.checked) {
                poseChanged(roll, pitch, yaw)
            }
        }
    }
    function degToRad(degrees) {
        return degrees * (Math.PI / 180);
    }

    function radToDeg(radians) {
        return radians * (180 / Math.PI);
    }
    Component {
        id: circularGaugeStyle
        CircularGaugeStyle {
            minimumValueAngle: -90
            maximumValueAngle: 90
            tickmarkStepSize: 15
            needle: Rectangle {
                y: outerRadius * 0.15
                implicitWidth: outerRadius * 0.03
                implicitHeight: outerRadius * 0.9
                antialiasing: true
                color: "steelblue"
            }
            tickmark: Rectangle {
                implicitHeight: outerRadius * 0.06
                implicitWidth: outerRadius * 0.02
                color: styleData.value < -20 || styleData.value > 20 ? "red" : "steelblue"
            }
            minorTickmark: Rectangle {
                implicitHeight: outerRadius * 0.03
                implicitWidth: outerRadius * 0.01
                color: styleData.value < -20 || styleData.value > 20 ? "red" : "lightsteelblue"
            }

            tickmarkLabel: Text {
                text: styleData.value
                color: styleData.value < -20 || styleData.value > 20 ? "red" : "steelblue"
            }
        }
    }
}
