//import QtQuick 2.6
//import QtQuick.Window 2.2

//Window {
//    visible: true
//    width: 640
//    height: 480
//    title: qsTr("Hello World")

//    MouseArea {
//        anchors.fill: parent
//        onClicked: {
//            console.log(qsTr('Clicked on background. Text: "' + textEdit.text + '"'))
//        }
//    }

//    TextEdit {
//        id: textEdit
//        text: qsTr("Enter some text...")
//        verticalAlignment: Text.AlignVCenter
//        anchors.top: parent.top
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.topMargin: 20
//        Rectangle {
//            anchors.fill: parent
//            anchors.margins: -10
//            color: "transparent"
//            border.width: 1
//        }
//    }
//}

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Particles 2.0

ApplicationWindow
{
    visible: true
    width: 640
    height: 480
    title: qsTr( "测试场景切换" )

    Item
    {
        id: scene_1
        visible: true
        anchors.fill: parent
        Text
        {
            anchors.centerIn: parent
            textFormat: Text.RichText
            text: qsTr( "<h1><font color=red>这是第一个场景</color></h1>" )
        }
        MouseArea
        {
            anchors.fill: parent
            onClicked: sceneTransition( scene_1, scene_2 )
        }
    }

    Item
    {
        id: scene_2
        visible: false
        anchors.fill: parent
        Text
        {
            anchors.centerIn: parent
            textFormat: Text.RichText
            text: qsTr( "<h1><font color=green>这是第二个场景</color></h1>" )
        }
        MouseArea
        {
            anchors.fill: parent
            onClicked: sceneTransition( scene_2, scene_1 )
        }
    }

    ParticleSystem
    {
        anchors.centerIn: parent
        ImageParticle
        {
            source: "qrc:///circle.png"
            colorVariation: 0.75
        }

        Emitter
        {
            id: emitter
            enabled: false
            emitRate: 2000
            size: 32
            lifeSpan: 4000
            velocity: AngleDirection
            {
                magnitude: 200
                angleVariation: 360
            }

            Timer
            {
                id: emitterTimer
                running: emitter.enabled
                interval: 500
                property var nextScene
                property var thisScene
                onTriggered:
                {
                    thisScene.visible = false;
                    nextScene.visible = true;
                    emitter.enabled = false;
                }
            }
        }
    }

    function sceneTransition( thisScene, nextScene )
    {
        emitterTimer.thisScene = thisScene;
        emitterTimer.nextScene = nextScene;
        emitter.enabled = true;
    }
}
