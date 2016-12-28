import QtQuick 2.3
import QtQuick.Window 2.2

//可以作为遥控器的基础控件
Window {
    id: root;
    visible: true;
    width: Screen.desktopAvailableWidth / 2;
    height: Screen.desktopAvailableHeight /2;
    Rectangle {
        id: dragItem;
        x: root.width / 2;
        y: root.height / 2;
        width: root.width / 10;
        height: root.width / 10;
        radius: root.width / 20
        color: "red"
        Drag.active: dragArea.drag.active;
        Drag.supportedActions: Qt.MoveAction;
        Drag.dragType: Drag.Automatic;
        Drag.mimeData: {"color": color, "width": width, "height": height};

        MouseArea {
            id: dragArea;
            anchors.fill: parent;
            drag.target: parent;

            onReleased: {
                dragItem.x = root.width / 2;
                dragItem.y = root.height / 2;
            }
        }
    }
    Text {
        id: text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: "postion"
    }

    DropArea {
        id: dropContainer
        anchors.fill: parent
        z: -1
        onPositionChanged: {
            drag.accepted = true;
            dragItem.x = drag.x;
            dragItem.y = drag.y;
           console.log("position changed: x,y ", drag.x, drag.y)
            text.text = drag.x;
        }
    }
}
