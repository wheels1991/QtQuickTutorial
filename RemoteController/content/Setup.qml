﻿import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

//设置界面
Item {
    id: page
    property double topRadius: 87
    property double topInterval: 15
    property double bottomRadius: 90
    property double bottomInterval: 60
    property double armLength: 40
    property double cardanHeight: 0
    property double linkLength: 115
    property double xyzRange: 30
    property double abcRange: 20
    property double zCentralPos: 96.5
    property bool linkType: false
    signal parasChanged(double tR, double tI, double bR, double bI,
                        double aL, double cH, double lL, double xyz,
                        double abc, double zPos, bool type)
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        Repeater {
            model: ListModel {
                ListElement {label: qsTr("Top Radius"); defaultValue: 87}
                ListElement {label: qsTr("Top Interval"); defaultValue: 15}
                ListElement {label: qsTr("Bottom Radius"); defaultValue: 90}
                ListElement {label: qsTr("Bottom Interval"); defaultValue: 60}
                ListElement {label: qsTr("Arm length"); defaultValue: 40}
                ListElement {label: qsTr("Cardan height"); defaultValue: 0}
                ListElement {label: qsTr("Link length"); defaultValue: 115}
                ListElement {label: qsTr("XYZ range"); defaultValue: 30}
                ListElement {label: qsTr("ABC range"); defaultValue: 20}
                ListElement {label: qsTr("Z centralPos"); defaultValue: 96.5}
            }
            Row {
                Layout.fillWidth: true
                Label {
                    width: parent.width * 0.4
                    text: label
                }
                SpinBox {
                    id: spinBox
                    width: parent.width * 0.6
                    value: defaultValue
                    stepSize: 1
                    decimals: 2     //两位小数
                    minimumValue: 0.0
                    maximumValue: 1000.0
                    onValueChanged: {
                        switch(index) {
                        case 0:
                            topRadius = value
                            break;
                        case 1:
                            topInterval = value
                            break;
                        case 2:
                            bottomRadius = value
                            break;
                        case 3:
                            bottomInterval = value
                            break;
                        case 4:
                            armLength = value
                            break;
                        case 5:
                            cardanHeight = value
                            break;
                        case 6:
                            linkLength = value
                            break;
                        case 7:
                            xyzRange = value
                            break;
                        case 8:
                            abcRange = value
                            break;
                        case 9:
                            zCentralPos = value
                            break;
                        }
                    }
                }
            }
        }
        Row {
            Layout.fillWidth: true
            Label {
                width: parent.width * 0.4
                text: "Type"
            }
            ComboBox {
                model: ["外摆", "内摆"]
                width: parent.width * 0.6
                onCurrentIndexChanged: {
                    if (currentText == "外摆") {
                        linkType = false
                    } else {
                        linkType = true
                    }
                }
            }
        }
        Button {
            text: qsTr("更新参数")
            focus: true
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: page.width / 5
                    implicitHeight:implicitWidth / 2
                    radius: control.height / 4
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.pressed ? "steelblue" : "lightsteelblue"}
                        GradientStop { position: 1 ; color: control.pressed ? "steelblue" : "lightsteelblue"}
                    }
                }
            }
            onClicked: {
                page.parasChanged(topRadius, topInterval,
                                  bottomRadius, bottomInterval,
                                  armLength, cardanHeight,
                                  linkLength, xyzRange,
                                  abcRange, zCentralPos, linkType);
            }
        }
    }
}
