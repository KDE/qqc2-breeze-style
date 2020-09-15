/*
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami

Item {
    id: root

    property alias control: root.parent

    implicitWidth: 32
    implicitHeight: 32

    Kirigami.ShadowedRectangle {
        id: mainBackground
        //WTF: Sometimes hovered is true for all buttons in a section of a Kirigami app. It's hard to know when this will happen.
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
            color: control.highlighted || control.visualFocus || control.hovered ?
                    Kirigami.Theme.focusColor :
                    Kirigami.ColorUtils.linearInterpolation(mainBackground.color, Kirigami.Theme.textColor, 0.3)
            width: 1
        }
        shadow {
            color: Qt.rgba(0,0,0,0.2)
            size: control.flat || control.down || !control.enabled ? 0 : 3
            yOffset: 1
        }
    }

    FocusRect {
        baseRadius: mainBackground.radius
        visible: control.visualFocus
    }

    BackgroundGradient {
        baseRadius: mainBackground.radius
        visible: !(control.flat || control.down || control.hovered) && control.enabled
    }
}
