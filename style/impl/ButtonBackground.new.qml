/*
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: mainBackground

    property alias control: mainBackground.parent

    implicitWidth: Kirigami.Units.mediumControlHeight
    implicitHeight: Kirigami.Units.mediumControlHeight

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
    border {
        color: control.highlighted || control.visualFocus || control.hovered ?
                Kirigami.Theme.focusColor :
                Kirigami.ColorUtils.tintWithAlpha(mainBackground.color, Kirigami.Theme.textColor, 0.3)
        width: Kirigami.Units.smallBorder
    }

    radius: Kirigami.Units.smallRadius

    Kirigami.ShadowedRectangle {
        id: shadow
        anchors.fill: parent
        visible: !control.flat && !control.down && control.enabled
        z: -1
        radius: mainBackground.radius
        shadow {
            color: Qt.rgba(0,0,0,0.2)
            size: 3
            yOffset: 1
        }
    }

    FocusRect {
        baseRadius: mainBackground.radius
        visible: control.visualFocus || control.highlighted
    }

    BackgroundGradient {
        baseRadius: mainBackground.radius
        visible: !(control.flat || control.down || control.hovered) && control.enabled
    }
}
