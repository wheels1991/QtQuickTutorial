import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Item {
    id: page
    property double px: 0
    property double py: 0
    property double pz: 100
    property double pa: 0
    property double pb: 0
    property double pc: 0
    signal poseChanged(double Px, double Py, double Pz,
                       double Pa, double Pb, double Pc)
    ColumnLayout {
        anchors.fill: parent
        Repeater {
            model: ListModel {
                ListElement { label: "X轴: "; maxValue: 50; minValue: -50; v: 0}
                ListElement { label: "Y轴: "; maxValue: 50; minValue: -50; v: 0}
                ListElement { label: "Z轴: "; maxValue: 150; minValue: 100; v: 100}
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
                        page.poseChanged(page.px, page.py, page.pz,
                                         page.pa, page.pb, page.pc)
                        labelID.text = label + value
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

                    }
                }
            }
        }
    }
}
