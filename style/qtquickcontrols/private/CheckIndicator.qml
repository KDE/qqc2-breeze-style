import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import org.kde.kirigami 2.14 as Kirigami

Kirigami.ShadowedRectangle {
    id: root

    property alias control: root.parent

    implicitWidth: Kirigami.Units.gridUnit
    implicitHeight: Kirigami.Units.gridUnit

    x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
    y: control.topPadding + (control.availableHeight - height) / 2

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false
    color: control.down || control.checked ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor

    radius: 3

    border {
        width: 1
        color: control.down || control.checked || control.highlighted || control.visualFocus || control.hovered ?
                Kirigami.Theme.highlightColor :
                Color.blend(root.color, Kirigami.Theme.textColor, 0.3)
    }

    shadow {
        color: Qt.rgba(0,0,0,0.2)
        size: control.down ? 0 : 2
        yOffset: 1
    }

    Item {
        id: checkmark
        anchors.centerIn: parent
        width: 12
        height: 12
        Rectangle {
            id: lineClBc
            antialiasing: true
            rotation: 45
            anchors.left: parent.left
            y: 7
            width: 5
            height: 2
            color: Kirigami.Theme.textColor
        }
        Rectangle {
            id: lineBcTr
            antialiasing: true
            rotation: -45
            anchors.right: parent.right
            y: 5
            width: 10
            height: 2
            color: Kirigami.Theme.textColor
        }
        visible: control.checkState === Qt.Checked
    }

    Item {
        id: partialCheckmark
        visible: control.checkState === Qt.PartiallyChecked
        anchors.centerIn: parent
        width: 12
        height: 2

        Rectangle {
            anchors.left: parent.left
            height: parent.height
            width: height
            color: Kirigami.Theme.textColor
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: height
            color: Kirigami.Theme.textColor
        }

        Rectangle {
            anchors.right: parent.right
            height: parent.height
            width: height
            color: Kirigami.Theme.textColor
        }
    }

    FocusRect {
        baseRadius: root.radius
        visible: control.visualFocus
    }
}
