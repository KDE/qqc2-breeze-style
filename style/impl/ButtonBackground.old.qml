/*
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

Kirigami.ShadowedRectangle {
    id: mainBackground
    
    property alias control: mainBackground.parent

    implicitWidth: Kirigami.Units.mediumControlHeight
    implicitHeight: Kirigami.Units.mediumControlHeight
    
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
    radius: Kirigami.Units.smallRadius
    border {
        color: control.highlighted || control.visualFocus || control.hovered ?
                Kirigami.Theme.focusColor :
                Kirigami.ColorUtils.tintWithAlpha(mainBackground.color, Kirigami.Theme.textColor, 0.3)
        width: Kirigami.Units.smallBorder
    }
    shadow {
        color: Qt.rgba(0,0,0,0.2)
        size: control.flat || control.down || !control.enabled ? 0 : 3
        yOffset: 1
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
