import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Fusion 2.12
import QtQuick.Controls.Fusion.impl 2.12

Rectangle {
    id: groove

    property Item control
    property real offset
    property real progress
    property real visualProgress

    x: control.horizontal ? 0 : (control.availableWidth - width) / 2
    y: control.horizontal ? (control.availableHeight - height) / 2 : 0

    implicitWidth: control.horizontal ? 160 : 5
    implicitHeight: control.horizontal ? 5 : 160
    width: control.horizontal ? control.availableWidth : implicitWidth
    height: control.horizontal ? implicitHeight : control.availableHeight

    radius: 2
    border.color: Fusion.outline(control.palette)
    scale: control.horizontal && control.mirrored ? -1 : 1

    gradient: Gradient {
        GradientStop {
            position: 0
            color: Qt.darker(Fusion.grooveColor(groove.control.palette), 1.1)
        }
        GradientStop {
            position: 1
            color: Qt.lighter(Fusion.grooveColor(groove.control.palette), 1.1)
        }
    }

    Rectangle {
        x: groove.control.horizontal ? groove.offset * parent.width : 0
        y: groove.control.horizontal ? 0 : groove.visualProgress * parent.height
        width: groove.control.horizontal ? groove.progress * parent.width - groove.offset * parent.width : 5
        height: groove.control.horizontal ? 5 : groove.progress * parent.height - groove.offset * parent.height

        radius: 2
        border.color: Qt.darker(Fusion.highlightedOutline(groove.control.palette), 1.1)

        gradient: Gradient {
            GradientStop {
                position: 0
                color: Fusion.highlight(groove.control.palette)
            }
            GradientStop {
                position: 1
                color: Qt.lighter(Fusion.highlight(groove.control.palette), 1.2)
            }
        }
    }
}
