

import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

Item {
    id: indicator
    implicitWidth: 38
    implicitHeight: 32

    property Item control
    property alias handle: handle

    Material.elevation: 1

    Rectangle {
        width: parent.width
        height: 14
        radius: height / 2
        y: parent.height / 2 - height / 2
        color: indicator.control.enabled ? (indicator.control.checked ? indicator.control.Material.switchCheckedTrackColor : indicator.control.Material.switchUncheckedTrackColor)
                               : indicator.control.Material.switchDisabledTrackColor
    }

    Rectangle {
        id: handle
        x: Math.max(0, Math.min(parent.width - width, indicator.control.visualPosition * parent.width - (width / 2)))
        y: (parent.height - height) / 2
        width: 20
        height: 20
        radius: width / 2
        color: indicator.control.enabled ? (indicator.control.checked ? indicator.control.Material.switchCheckedHandleColor : indicator.control.Material.switchUncheckedHandleColor)
                               : indicator.control.Material.switchDisabledHandleColor

        Behavior on x {
            enabled: !indicator.control.pressed
            SmoothedAnimation {
                duration: 300
            }
        }
        layer.enabled: indicator.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: indicator.Material.elevation
        }
    }
}
