/*
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami

Item {
    id: root

    readonly property alias control: root.parent

    implicitWidth: 32
    implicitHeight: 32

    Kirigami.ShadowedRectangle {
        id: mainBackground
        visible: !control.flat || control.down || control.checked || control.highlighted || control.visualFocus || control.hovered
        Kirigami.Theme.colorSet: Kirigami.Theme.Button
        Kirigami.Theme.inherit: false
        color: {
            if (control.down || control.checked ) {
                Kirigami.Theme.alternateBackgroundColor
            } else if (control.flat) {
                "transparent"
            } else {
                Kirigami.Theme.backgroundColor
            }
        }
        anchors.fill: parent
        radius: 3
        border {
            color: /*control.down || control.checked ||*/ control.highlighted || control.visualFocus || control.hovered ?
                    Kirigami.Theme.highlightColor :
                    Color.blend(mainBackground.color, Kirigami.Theme.textColor, 0.3)
            width: mainBackground.visible ? 1 : 0
        }
        shadow {
            color: Qt.rgba(0,0,0,0.2)
            size: control.flat || control.down ? 0 : 3
            yOffset: 1
        }
    }

    FocusRect {
        baseRadius: mainBackground.radius
        visible: control.visualFocus
    }

    BackgroundGradient {
        baseRadius: mainBackground.radius
        visible: !(control.flat || control.down || control.hovered)
    }
}
