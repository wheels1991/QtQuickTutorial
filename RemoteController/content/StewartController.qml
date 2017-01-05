import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Item {
    id: page
    property bool isEnable: checkBox.checked
    property double px: 0
    property double py: 0
    property double pz: 96.5
    property double pa: 0
    property double pb: 0
    property double pc: 0
    property double xyzRange: 30
    property double abcRange: 20
    property double zCentralPos: 96.5

    signal poseChanged(double Px, double Py, double Pz,
                       double Pa, double Pb, double Pc)

    ColumnLayout {
        anchors.fill: parent
        Repeater {
            model: ListModel {
                ListElement { label: qsTr("X轴: ")}
                ListElement { label: qsTr("Y轴: ")}
                ListElement { label: qsTr("Z轴: ")}
                ListElement { label: qsTr("A轴: ")}
                ListElement { label: qsTr("B轴: ")}
                ListElement { label: qsTr("C轴: ")}
            }
            Row {
                Layout.fillWidth: true
                Label {
                    id: labelID
                    width: parent.width * 0.2
                    text: label + (slider.value).toFixed(1)
                }
                Slider {
                    id: slider
                    width: parent.width * 0.8
                    stepSize: 0.2
                    value: switch (index) {
                           case 0 :
                               return 0
                           case 1:
                               return 0
                           case 2:
                               return zCentralPos
                           case 3:
                               return 0
                           case 4:
                               return 0
                           case 5:
                               return 0
                            }
                    maximumValue:switch (index) {
                                      case 0 :
                                          return xyzRange
                                      case 1:
                                          return xyzRange
                                      case 2:
                                          return zCentralPos + xyzRange
                                      case 3:
                                          return abcRange
                                      case 4:
                                          return abcRange
                                      case 5:
                                          return abcRange
                              }
                    minimumValue:switch (index) {
                                      case 0 :
                                          return -xyzRange
                                      case 1:
                                          return -xyzRange
                                      case 2:
                                          return zCentralPos - xyzRange
                                      case 3:
                                          return -abcRange
                                      case 4:
                                          return -abcRange
                                      case 5:
                                          return -abcRange
                                  }
                    style: sliderStyle
                    onValueChanged: {
                        switch (index) {
                            case 0:
                                px = value
                                break;
                            case 1:
                                py = value
                                break;
                            case 2:
                                pz = value
                                break;
                            case 3:
                                pa = value
                                break;
                            case 4:
                                pb = value
                                break;
                            case 5:
                                pc = value
                                break;
                        }
                        page.poseChanged(px, py, pz, pa, pb, pc)
                        labelID.text = label + value                            //实时修改Label的显示值
                    }
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

    }

    Component {
        id: sliderStyle
        SliderStyle {
            groove: Item {
                implicitWidth: control.width
                Rectangle {
                    height: width / 80
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    color: "gray"
                    Rectangle {
                        antialiasing: true
                        color: "lightsteelblue"
                        height: parent.height
                        width: parent.width * (control.value - control.minimumValue) / (control.maximumValue - control.minimumValue)
                    }
                }
            }
            handle: Rectangle {
                anchors.centerIn: parent
                color: "steelblue"
                implicitWidth: control.width / 15
                implicitHeight: implicitWidth
                radius: implicitWidth / 2
            }
        }
    }
}
