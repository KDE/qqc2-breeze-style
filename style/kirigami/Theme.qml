/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.4

pragma Singleton


QtObject {
    id: theme

    property color textColor: palette.windowText
    property color disabledTextColor: disabledPalette.windowText

    property color highlightColor: palette.highlight
    property color highlightedTextColor: palette.highlightedText
    property color backgroundColor: palette.window
    property color alternateBackgroundColor: hsvValueMix(theme.highlightColor, theme.backgroundColor)
    property color activeTextColor: palette.highlight
    property color activeBackgroundColor: palette.highlight
    property color linkColor: palette.link
    property color linkBackgroundColor: hsvValueMix(theme.linkColor, theme.backgroundColor)
    property color visitedLinkColor: palette.linkVisited
    property color visitedLinkBackgroundColor: hsvValueMix(theme.visitedLinkColor, theme.backgroundColor)
    property color hoverColor: palette.highlight
    property color focusColor: palette.highlight
    property color negativeTextColor: "#DA4453"
    property color negativeBackgroundColor: hsvValueMix(theme.negativeTextColor, theme.backgroundColor)
    property color neutralTextColor: "#F67400"
    property color neutralBackgroundColor: hsvValueMix(theme.neutralTextColor, theme.backgroundColor)
    property color positiveTextColor: "#27AE60"
    property color positiveBackgroundColor: hsvValueMix(theme.positiveTextColor, theme.backgroundColor)

    property color buttonTextColor: palette.buttonText
    property color buttonBackgroundColor: palette.button
    property color buttonAlternateBackgroundColor: hsvValueMix(theme.buttonFocusColor, theme.buttonBackgroundColor)
    property color buttonHoverColor: palette.highlight
    property color buttonFocusColor: palette.highlight

    property color viewTextColor: palette.text
    property color viewBackgroundColor: palette.base
    property color viewAlternateBackgroundColor: palette.alternateBase
    property color viewHoverColor: palette.highlight
    property color viewFocusColor: palette.highlight

    property color selectionTextColor: palette.highlightedText
    property color selectionBackgroundColor: palette.highlight
    property color selectionAlternateBackgroundColor: hsvValueMix(theme.selectionBackgroundColor, theme.backgroundColor)
    property color selectionHoverColor: palette.highlight
    property color selectionFocusColor: palette.highlight

    property color tooltipTextColor: palette.toolTipText
    property color tooltipBackgroundColor: palette.toolTipBase
    property color tooltipAlternateBackgroundColor: palette.window
    property color tooltipHoverColor: palette.highlight
    property color tooltipFocusColor: palette.highlight

    property color complementaryTextColor: hslLightnessInvert(theme.textColor)
    property color complementaryBackgroundColor: hslLightnessInvert(theme.backgroundColor)
    property color complementaryAlternateBackgroundColor: hslLightnessInvert(theme.alternateBackgroundColor)
    property color complementaryHoverColor: hslLightnessInvert(theme.hoverColor)
    property color complementaryFocusColor: hslLightnessInvert(theme.focusColor)

    property color headerTextColor: palette.text
    property color headerBackgroundColor: palette.base
    property color headerAlternateBackgroundColor: palette.alternateBase
    property color headerHoverColor: palette.highlight
    property color headerFocusColor: palette.highlight

    property font defaultFont: fontMetrics.font
    property font smallFont: {
        let font = fontMetrics.font
        if (!!font.pixelSize) {
            font.pixelSize =- 2
        } else {
            font.pointSize =- 2
        }
        return font
    }

    property list<QtObject> children: [
        FontMetrics {
            id: fontMetrics
        },
        SystemPalette {
            id: palette
            colorGroup: SystemPalette.Active
        },
        SystemPalette {
            id: disabledPalette
            colorGroup: SystemPalette.Disabled
        }
    ]

    function __propagateColorSet(object, context) {}

    function __propagateTextColor(object, color) {}
    function __propagateBackgroundColor(object, color) {}
    function __propagatePrimaryColor(object, color) {}
    function __propagateAccentColor(object, color) {}
    
    function hsvValueMix(color1, color2) {
        return Qt.hsva(
            color1.hsvHue,
            color1.hsvSaturation,
            (color1.hsvValue + color2.hsvValue)/2,
            color1.a
        )
    }

    function hslLightnessInvert(color) {
        return Qt.hsla(
            color1.hslHue,
            color1.hslSaturation,
            1-color1.hslLightness,
            color.a
        )
    }
}
