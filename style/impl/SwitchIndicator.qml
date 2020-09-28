import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import org.kde.kirigami 2.14 as Kirigami

Item {
    id: root

    property alias control: root.parent

    implicitWidth: implicitHeight*2
    implicitHeight: Kirigami.Units.gridUnit

    x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
    y: (control.height - height) / 2

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 3
        radius: height / 2
        color: control.down || control.checked ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
        border {
            width: 1
            color: control.down || control.checked || control.highlighted ?
                Kirigami.Theme.focusColor :
                Kirigami.ColorUtils.tintWithAlpha(background.color, Kirigami.Theme.textColor, 0.3)
        }
    }

    Kirigami.ShadowedRectangle {
        id: handle
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: height
        radius: height / 2
        color: Kirigami.Theme.backgroundColor
        border {
            width: 1
            color: control.down || control.highlighted || control.visualFocus || control.hovered ?
                Kirigami.Theme.focusColor :
                Kirigami.ColorUtils.tintWithAlpha(handle.color, Kirigami.Theme.textColor, 0.3)
        }

        shadow {
            color: Qt.rgba(0,0,0,0.2)
            size: control.down ? 0 : 2
            yOffset: 1
        }
        
        FocusRect {
            baseRadius: handle.radius
            visible: control.visualFocus
        }
    }
    
    states: [
        State {
            name: "checked"
            when: control.checked
            AnchorChanges {
                target: handle
                anchors.left: undefined
                anchors.right: parent.right
            }
        }
    ]
    
    transitions: [
        Transition {
            AnchorAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutCubic
            }
        }
    ]
}
