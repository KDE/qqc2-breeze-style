import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import org.kde.kirigami 2.14 as Kirigami

Kirigami.ShadowedRectangle {
    id: root

    property alias control: root.parent

    implicitWidth: Kirigami.Units.gridUnit
    implicitHeight: Kirigami.Units.gridUnit

    x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
    y: (control.height - height) / 2

    radius: width / 2

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false
    color: control.down || control.checked ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor

    border {
        width: 1
        color: control.down || control.checked || control.highlighted || control.visualFocus || control.hovered ?
                Kirigami.Theme.focusColor :
                Kirigami.ColorUtils.tintWithAlpha(root.color, Kirigami.Theme.textColor, 0.3)
    }

    shadow {
        color: Qt.rgba(0,0,0,0.2)
        size: control.down ? 0 : 2
        yOffset: 1
    }

    Rectangle {
        anchors.centerIn: parent
        width: 8
        height: 8
        radius: width / 2
        color: Kirigami.Theme.textColor
        visible: control.checked
    }

    FocusRect {
        baseRadius: root.radius
        visible: control.visualFocus
    }
}
