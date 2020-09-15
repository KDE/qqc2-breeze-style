import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Fusion 2.12
import QtQuick.Controls.Fusion.impl 2.12

Rectangle {
    id: panel

    property Item control
    property bool highlighted: control.highlighted

    visible: !control.flat || control.down || control.checked

    color: Fusion.buttonColor(control.palette, panel.highlighted, control.down || control.checked, control.hovered)
    gradient: control.down || control.checked ? null : buttonGradient

    Gradient {
        id: buttonGradient
        GradientStop {
            position: 0
            color: Fusion.gradientStart(Fusion.buttonColor(panel.control.palette, panel.highlighted, panel.control.down, panel.control.hovered))
        }
        GradientStop {
            position: 1
            color: Fusion.gradientStop(Fusion.buttonColor(panel.control.palette, panel.highlighted, panel.control.down, panel.control.hovered))
        }
    }

    radius: 2
    border.color: Fusion.buttonOutline(control.palette, panel.highlighted || control.visualFocus, control.enabled)

    Rectangle {
        x: 1; y: 1
        width: parent.width - 2
        height: parent.height - 2
        border.color: Fusion.innerContrastLine
        color: "transparent"
        radius: 2
    }
}
