import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import stewart.lib 1.1

Item {
    id: page
    property double px: 0
    property double py: 0
    property double pz: 278
    property double pa: 0
    property double pb: 0
    property double pc: 0

    property double joint0: 0
    property double joint1: 0
    property double joint2: 0
    property double joint3: 0
    property double joint4: 0
    property double joint5: 0
    signal poseChanged(double Px, double Py, double Pz,
                       double Pa, double Pb, double Pc)
    signal jointsChanged(double j0, double j1, double j2,
                         double j3, double j4, double j5)
    Stewart {
        id: stewart
    }

    ColumnLayout {
        anchors.fill: parent
        Repeater {
            model: ListModel {
                ListElement { label: "X轴: "; maxValue: 50; minValue: -50; v: 0}
                ListElement { label: "Y轴: "; maxValue: 50; minValue: -50; v: 0}
                ListElement { label: "Z轴: "; maxValue: 300; minValue: 260; v: 278}
                ListElement { label: "A轴: "; maxValue: 20; minValue: -20; v: 0}
                ListElement { label: "B轴: "; maxValue: 20; minValue: -20; v: 0}
                ListElement { label: "C轴: "; maxValue: 20; minValue: -20; v: 0}
            }
            Row {
                Layout.fillWidth: true
                Label {
                    id: labelID
                    width: parent.width / 10
                    text: label + v
                }
                Slider {
                    width: parent.width * 0.9
                    stepSize: 0.5
                    value: v
                    maximumValue: maxValue
                    minimumValue: minValue
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
                        stewart.SetPos(px, py, pz, pa, pb, pc)
                        labelID.text = label + value                            //实时修改Label的显示值

                    }
                }
            }
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
