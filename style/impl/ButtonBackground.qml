/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

// TODO: Maybe use a loader here one day. Make sure nothing breaks.
// Kirigami ShadowedRectangle doesn't have a gradient property, which could be an issue in some cases
Kirigami.ShadowedRectangle {
    id: mainBackground

    property alias control: mainBackground.parent

    // Segmented button control group properties
    property T.ButtonGroup buttonGroup: control.T.ButtonGroup.group
    property bool zeroOrLessSpacing: control.parent.hasOwnProperty("spacing") && control.parent.spacing <= 0
    property bool isInButtonGroup: Boolean(buttonGroup)
    property bool isFirstInButtonGroup: isInButtonGroup && buttonGroup.buttons[0] == control
    property bool isLastInButtonGroup: isInButtonGroup && buttonGroup.buttons[buttonGroup.buttons.length-1] == control
    property real leftRadius: !isInButtonGroup || (isLastInButtonGroup && zeroOrLessSpacing) ? radius : 0
    property real rightRadius: !isInButtonGroup || (isFirstInButtonGroup && zeroOrLessSpacing) ? radius : 0

    radius: Kirigami.Units.smallRadius
    corners {
        topLeftRadius: leftRadius
        topRightRadius: rightRadius
        bottomLeftRadius: leftRadius
        bottomRightRadius: rightRadius
    }

    implicitWidth: implicitHeight
    implicitHeight: Kirigami.Units.mediumControlHeight

    visible: !control.flat || control.editable || control.down || control.checked || control.highlighted || control.visualFocus || control.hovered

    color: {
        if (control.down || control.checked ) {
            Kirigami.Theme.alternateBackgroundColor
        } else if (control.flat) {
            return Qt.rgba(
                control.palette.button.r,
                control.palette.button.g,
                control.palette.button.b,
                0)
        } else {
            control.palette.button
        }
    }

    border {
        color: {
            if (control.enabled && control.down || control.checked || control.highlighted || control.visualFocus || control.hovered) {
                return Kirigami.Theme.focusColor
//             } else if (control.flat) {
                //return "transparent"
            } else {
                return Kirigami.Theme.separatorColor
            }
        }
        width: Kirigami.Units.smallBorder
    }

    Behavior on color {
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    SmallShadow {
        id: shadowRect
        opacity: control.down ? 0 : 1
        visible: !control.editable && !control.flat && control.enabled
        z: -1
        radius: mainBackground.radius
    }

    FocusRect {
        id: focusRect
        baseRadius: mainBackground.radius
        visible: control.visualFocus
    }

    BackgroundGradient {
        id: bgGradient
        radius: mainBackground.radius
        opacity: control.down || control.hovered ? 0 : 1
        visible: !control.editable && !control.flat && control.enabled
    }
}
