/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: mainBackground

    property alias control: mainBackground.parent

    implicitWidth: implicitHeight
    implicitHeight: Kirigami.Units.mediumControlHeight

    visible: !control.flat || control.editable || control.down || control.checked || control.highlighted || control.visualFocus || control.hovered

    color: {
        if (control.down || control.checked ) {
            Kirigami.Theme.alternateBackgroundColor
        } else if (control.flat) {
            return "transparent"
        } else {
            control.palette.button
        }
    }

    border {
        color: {
            if (control.enabled && control.down || control.checked || control.highlighted || control.visualFocus || control.hovered) {
                return Kirigami.Theme.highlightColor
//             } else if (control.flat) {
                //return "transparent"
            } else {
                return Kirigami.Theme.separatorColor
            }
        }
//             Kirigami.ColorUtils.tintWithAlpha(mainBackground.color, Kirigami.Theme.textColor, 0.3)
        width: Kirigami.Units.smallBorder
    }

    radius: Kirigami.Units.smallRadius

    SmallShadow {
        id: shadowRect
        visible: !control.editable && !control.flat && !control.down && control.enabled
        z: -1
//         showShadow: !control.editable && !control.down && control.enabled
        radius: mainBackground.radius
    }

    FocusRect {
        id: focRect
        baseRadius: mainBackground.radius
        visible: control.visualFocus
    }

    BackgroundGradient {
        id: bgGradient
        radius: mainBackground.radius
//         rotation: control.checked ? 180 : 0
        visible: control.enabled && !control.editable && !control.flat && !control.down && !control.hovered
    }
}
