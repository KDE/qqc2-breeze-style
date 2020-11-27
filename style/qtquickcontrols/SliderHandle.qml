//NOTE: remove this
import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Item {
    id: root
    implicitWidth: initialSize
    implicitHeight: initialSize

    property real value: 0
    property bool handleHasFocus: false
    property bool handlePressed: false
    property bool handleHovered: false
    readonly property int initialSize: 13
    readonly property var control: parent

    Rectangle {
        id: handleRect
        width: parent.width
        height: parent.height
        radius: width / 2
        scale: root.handlePressed ? 1.5 : 1
        color: control.enabled ? root.control.Material.accentColor : root.control.Material.sliderDisabledColor

        Behavior on scale {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Ripple {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 22; height: 22
        pressed: root.handlePressed
        active: root.handlePressed || root.handleHasFocus || root.handleHovered
        color: root.control.Material.highlightedRippleColor
    }
}
