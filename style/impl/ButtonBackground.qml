/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.19 as Kirigami

import "." as Impl

// TODO: Maybe use a loader here one day. Make sure nothing breaks.
// Kirigami ShadowedRectangle doesn't have a gradient property, which could be an issue in some cases
Kirigami.ShadowedRectangle {
    id: mainBackground

    property T.AbstractButton control: mainBackground.parent

    // Segmented button control group properties
    property T.ButtonGroup buttonGroup: control.T.ButtonGroup.group
    property bool zeroOrLessSpacing: control.parent.hasOwnProperty("spacing") && control.parent.spacing <= 0
    property bool isInButtonGroup: Boolean(buttonGroup)
    property bool isFirstInButtonGroup: isInButtonGroup && buttonGroup.buttons[0] == control
    property bool isLastInButtonGroup: isInButtonGroup && buttonGroup.buttons[buttonGroup.buttons.length-1] == control
    property real leftRadius: !isInButtonGroup || (isLastInButtonGroup && zeroOrLessSpacing) ? radius : 0
    property real rightRadius: !isInButtonGroup || (isFirstInButtonGroup && zeroOrLessSpacing) ? radius : 0

    property color flatColor: Qt.rgba(
        Kirigami.Theme.backgroundColor.r,
        Kirigami.Theme.backgroundColor.g,
        Kirigami.Theme.backgroundColor.b,
        0
    )
    property bool highlightBackground: control.down || control.checked
    property bool highlightBorder: control.enabled && control.down || control.checked || control.highlighted || control.visualFocus || control.hovered

    radius: Impl.Units.smallRadius
    corners {
        topLeftRadius: leftRadius
        topRightRadius: rightRadius
        bottomLeftRadius: leftRadius
        bottomRightRadius: rightRadius
    }

    implicitWidth: implicitHeight
    implicitHeight: Impl.Units.mediumControlHeight

    visible: !control.flat || control.editable || control.down || control.checked || control.highlighted || control.visualFocus || control.hovered

    color: {
        if (highlightBackground) {
            return Kirigami.Theme.alternateBackgroundColor
        } else if (control.flat) {
            return flatColor
        } else {
            return Kirigami.Theme.backgroundColor
        }
    }

    border {
        color: {
            if (highlightBorder) {
                return Kirigami.Theme.focusColor
            } else {
                return Kirigami.Theme.separatorColor
            }
        }
        width: Impl.Units.smallBorder
    }

    Behavior on color {
        enabled: highlightBackground
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }
    Behavior on border.color {
        enabled: highlightBorder
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    SmallBoxShadow {
        opacity: control.down ? 0 : 1
        visible: !control.editable && !control.flat && control.enabled
        radius: mainBackground.radius
    }
    
    FocusRect {
        id: focusRect
        baseRadius: mainBackground.radius
        visible: control.visualFocus
    }
}
