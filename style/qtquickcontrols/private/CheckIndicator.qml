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
    color: control.checked ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
    radius: 3

    border {
        width: 1
        color: control.down || control.checked || control.highlighted || control.visualFocus || control.hovered ?
                Kirigami.Theme.highlightColor :
                Color.blend(indicator.color, Kirigami.Theme.textColor, 0.3)
    }
    
    shadow {
        color: Qt.rgba(0,0,0,0.2)
        size: control.down ? 0 : 2
        yOffset: 1
    }

    Kirigami.Icon {
        anchors.centerIn: parent
        width: 16
        height: 16
        source: control.checkState === Qt.PartiallyChecked ? "view-more-horizontal-symbolic" : "checkmark"
        visible: (control.checkState === Qt.Checked || control.checkState === Qt.PartiallyChecked)
    }

    FocusRect {
        baseRadius: indicator.radius
        visible: control.visualFocus
    }
}
