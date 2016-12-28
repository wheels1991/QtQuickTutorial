import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.0
import an.qt.ColorMaker 1.0

Window {
    visible: true
    width: 480
    height: 640
    title: qsTr("Hello World")

    Rectangle {
        id: rootItem
        anchors.fill: parent
        Text {
            id: timeLabel;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.leftMargin: 4;
            anchors.top: parent.top;
            anchors.topMargin: 40;
            font.pixelSize: 26;
        }
        ColorMaker {
            id: colorMaker;
            color: Qt.green;
        }

        Rectangle {
            id: colorRect;
            anchors.centerIn: parent;
            width: 200;
            height: 200;
            color: "blue";
        }


        function changeAlgorithm(button, algorithm){
            switch(algorithm)
            {
            case 0:
                button.text = "RandomRGB";
                break;
            case 1:
                button.text = "RandomRed";
                break;
            case 2:
                button.text = "RandomGreen";
                break;
            case 3:
                button.text = "RandomBlue";
                break;
            case 4:
                button.text = "LinearIncrease";
                break;
            }
        }
        Row {
            id:rowLayout
            anchors.bottom: rootItem.bottom
            anchors.horizontalCenter: rootItem.horizontalCenter
            spacing: 10

            Button {
                id: start;
                text: "start";
                onClicked: {
                    colorMaker.start();
                }
            }
            Button {
                id: stop;
                text: "stop";
                onClicked: {
                    colorMaker.stop();
                }
            }
            Button {
                id: colorAlgorithm;
                text: "RandomRGB";
                onClicked: {
                    var algorithm = (colorMaker.algorithm() + 1) % 5;
                    rootItem.changeAlgorithm(colorAlgorithm, algorithm);
                    colorMaker.setAlgorithm(algorithm);
                }
            }

            Button {
                id: quit;
                text: "quit";
                onClicked: {
                    Qt.quit();
                }
            }
        }

        Component.onCompleted: {
            colorMaker.color = Qt.rgba(0,180,120, 255);
            colorMaker.setAlgorithm(ColorMaker.LinearIncrease);
            rootItem.changeAlgorithm(colorAlgorithm, colorMaker.algorithm());
        }

        Connections {
            target: colorMaker;
            onCurrentTime:{
                timeLabel.text = strTime;
                timeLabel.color = colorMaker.timeColor;
            }
        }

        Connections {
            target: colorMaker;
            onColorChanged:{
                colorRect.color = color;
            }
        }
    }
}
