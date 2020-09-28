/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.4
import QtQuick.Window 2.2

pragma Singleton

/**
 * A set of values to define semantically sizes and durations
 * @inherit QtQuick.QtObject
 */
QtObject {
    id: units

    /**
     * The fundamental unit of space that should be used for sizes, expressed in pixels.
     * Given the screen has an accurate DPI settings, it corresponds to a width of
     * the capital letter M
     */
    property int gridUnit: fontMetrics.height

    /**
     * units.iconSizes provides access to platform-dependent icon sizing
     *
     * The icon sizes provided are normalized for different DPI, so icons
     * will scale depending on the DPI.
     *
     * Icon sizes from KIconLoader, adjusted to devicePixelRatio:
     * * small
     * * smallMedium
     * * medium
     * * large
     * * huge
     * * enormous
     *
     * Not devicePixelRation-adjusted::
     * * desktop
     */
    property QtObject iconSizes: QtObject {
        // Breeze
        property int defaultSize: fontMetrics.roundedIconSize(gridUnit)
        property int tiny: fontMetrics.roundedIconSize(8 * devicePixelRatio)
        property int tinySmall: fontMetrics.roundedIconSize(12 * devicePixelRatio)
        // Breeze
        property int small: fontMetrics.roundedIconSize(16 * devicePixelRatio)
        property int smallMedium: fontMetrics.roundedIconSize(22 * devicePixelRatio)
        property int medium: fontMetrics.roundedIconSize(32 * devicePixelRatio)
        property int large: fontMetrics.roundedIconSize(48 * devicePixelRatio)
        property int huge: fontMetrics.roundedIconSize(64 * devicePixelRatio)
        property int enormous: 128 * devicePixelRatio
    }

    //BEGIN Breeze Units
    property int smallBorder: devicePixelRatio
    property int mediumBorder: smallBorder*2
    property int largeBorder: smallBorder*4
    
    property int smallRadius: 3 * devicePixelRatio
    property int largeRadius: 6 * devicePixelRatio
    
    /*property int smallControlHeight: Math.max(
        iconSizes.defaultSize,
        fontMetrics.blockHeight
    ) + units.smallSpacing*2*/
    property int mediumControlHeight: Math.max(
        iconSizes.defaultSize,
        fontMetrics.blockHeight
    ) + units.largeSpacing*2

    function controlPadding(bgHeight, contHeight) {
        return Math.round(Math.abs(bgHeight - contHeight) / 2)
    }
    //END Breeze Units

    /**
     * Units.smallSpacing is the amount of spacing that should be used around smaller UI elements,
     * for example as spacing in Columns. Internally, this size depends on the size of
     * the default font as rendered on the screen, so it takes user-configured font size and DPI
     * into account.
     */
    property int smallSpacing: 4 * devicePixelRatio

    /**
     * Units.largeSpacing is the amount of spacing that should be used inside bigger UI elements,
     * for example between an icon and the corresponding text. Internally, this size depends on
     * the size of the default font as rendered on the screen, so it takes user-configured font
     * size and DPI into account.
     */
    property int largeSpacing: 8 * devicePixelRatio

    /**
     * Units.hugeSpacing is the amount of spacing that should be used inside bigger UI elements,
     * for example between an icon and the corresponding text. Internally, this size depends on
     * the size of the default font as rendered on the screen, so it takes user-configured font
     * size and DPI into account.
     */
    property int hugeSpacing: 12 * devicePixelRatio

    /**
     * The ratio between physical and device-independent pixels. This value does not depend on the \
     * size of the configured font. If you want to take font sizes into account when scaling elements,
     * use theme.mSize(theme.defaultFont), units.smallSpacing and units.largeSpacing.
     * The devicePixelRatio follows the definition of "device independent pixel" by Microsoft.
     */
    property real devicePixelRatio: Math.max(1, ((fontMetrics.font.pixelSize*0.75) / fontMetrics.font.pointSize))
    
    /**
     * units.shortDuration should be used for short animations, such as accentuating a UI event,
     * hover events, etc..
     */
    property int tinyDuration: 50

    /**
     * units.shortDuration should be used for short animations, such as accentuating a UI event,
     * hover events, etc..
     */
    property int shortDuration: 100

    /**
     * units.longDuration should be used for longer, screen-covering animations, for opening and
     * closing of dialogs and other "not too small" animations
     */
    property int longDuration: 200

    /**
     * units.veryLongDuration should be used for specialty animations that benefit
     * from being even longer than longDuration.
     */
    property int veryLongDuration: 400

    /**
     * time in ms by which the display of tooltips will be delayed.
     *
     * @sa ToolTip.delay property
     */
    property int toolTipDelay: 700

    /**
     * How much the mouse scroll wheel scrolls, expressed in lines of text.
     * Note: this is strictly for classical mouse wheels, touchpads 2 figer scrolling won't be affected
     */
    readonly property int wheelScrollLines: 3

    /**
     * metrics used by the default font
     */
    property variant fontMetrics: FontMetrics {
        /** Height of a capital letter
         * 
         * QFontEngine (private, used by QFontMetricsF) uses an 'H' to
         * calculate capHeight(), so the behavior should match the behavior
         * of QFontMetricsF::capHeight().
         * 
         * WARNING: Very Eurocentric. Be kind to your translators and use it
         * carefully. Don't make areas with text that are too small to look
         * good with or at least contain non-European languages.
         */
        property real capHeight: fontMetrics.tightBoundingRect("H").height

        /// Height of a full block character
        property int blockHeight: fontMetrics.tightBoundingRect('█').height

        function roundedIconSize(size) {
            if (size < 16) {
                return size;
            } else if (size < 22) {
                return 16;
            } else if (size < 32) {
                return 22;
            } else if (size < 48) {
                return 32;
            } else if (size < 64) {
                return 48;
            } else {
                return size;
            }
        }
    }
}
