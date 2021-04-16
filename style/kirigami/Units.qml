/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *  SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 *  SPDX-FileCopyrightText: 2021 Dan Leinir Turthra Jensen <admin@leinir.dk>
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Window 2.15
// Use QtQuickControlsPrivate.Settings.isMobile to avoid importing kirigami here which would cause a binding loop
import QtQuick.Controls 1.4 as QtQuickControls
import QtQuick.Controls.Private 1.0 as QtQuickControlsPrivate

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
    property int gridUnit: fontMetrics.height + fontMetrics.height % 2

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
        property int sizeForLabels: units.iconSizes.auto
        property int auto: fontMetrics.roundedIconSize(fontMetrics.height)
        property int tiny: fontMetrics.roundedIconSize(8 * devicePixelRatio)
        property int tinySmall: fontMetrics.roundedIconSize(12 * devicePixelRatio)
        // Breeze
        property int small: fontMetrics.roundedIconSize(16 * devicePixelRatio * (QtQuickControlsPrivate.Settings.isMobile ? 1.5 : 1))
        property int smallMedium: fontMetrics.roundedIconSize(22 * devicePixelRatio * (QtQuickControlsPrivate.Settings.isMobile ? 1.5 : 1))
        property int medium: fontMetrics.roundedIconSize(32 * devicePixelRatio * (QtQuickControlsPrivate.Settings.isMobile ? 1.5 : 1))
        property int large: fontMetrics.roundedIconSize(48 * devicePixelRatio * (QtQuickControlsPrivate.Settings.isMobile ? 1.5 : 1))
        property int huge: fontMetrics.roundedIconSize(64 * devicePixelRatio * (QtQuickControlsPrivate.Settings.isMobile ? 1.5 : 1))
        property int enormous: 128 * devicePixelRatio * (QtQuickControlsPrivate.Settings.isMobile ? 1.5 : 1)
        // TODO: Using larger sizes on mobile because that's what Kirigami normally does. Maybe don't do this in the future.
        //property int small: fontMetrics.roundedIconSize(16 * devicePixelRatio)
        //property int smallMedium: fontMetrics.roundedIconSize(22 * devicePixelRatio)
        //property int medium: fontMetrics.roundedIconSize(32 * devicePixelRatio)
        //property int large: fontMetrics.roundedIconSize(48 * devicePixelRatio)
        //property int huge: fontMetrics.roundedIconSize(64 * devicePixelRatio)
        //property int enormous: 128 * devicePixelRatio
    }

    //BEGIN Breeze Units
    // The default border width
    property int smallBorder: 1
    // Used for the focus ring
    property int mediumBorder: smallBorder*2
    // Usually for highlights on larger surfaces like Cards
    property int largeBorder: smallBorder*4

    // The default corner radius
    property int smallRadius: 3
    // Usually for larger surfaces like Cards
    property int largeRadius: smallRadius * 2

    // Used to underline checkbox labels
    property int focusUnderlineThickness: smallBorder
    // Used for tabs and items in sidebars
    property int highlightLineThickness: smallRadius

    property int grooveHeight: {
        let h = Math.floor(gridUnit/3);
        h += h % 2;
        return h;
    }

    property int thickGrooveHeight: {
        let h = Math.floor(gridUnit/1.5);
        h += h % 2;
        return h;
    }

    /// For things like checkboxes/radiobuttons/switches/slider handles
    property int inlineControlHeight: gridUnit

    // For small controls with a small amount of vertical padding
    property int smallControlHeight: gridUnit + units.smallSpacing*2

    // For medium controls with a medium amount of vertical padding
    property int mediumControlHeight: gridUnit + units.mediumSpacing*2

    // For large controls with a large amount of vertical padding
    property int largeControlHeight: gridUnit + units.largeSpacing*2

    property real horizontalPaddingRatio: Math.max(fontMetrics.height/fontMetrics.fullWidthCharWidth, 1)

    property int verySmallHorizontalPadding: Math.round(horizontalPaddingRatio * units.verySmallSpacing)

    property int smallHorizontalPadding: Math.round(horizontalPaddingRatio * units.smallSpacing)

    property int  mediumHorizontalPadding: Math.round(horizontalPaddingRatio * units.mediumSpacing)

    /**
     * These can work around the fact that units.fontMetrics doesn't account for custom font sizes used by different controls
     */
    function dynamicControlHeight(iconHeight, pointSize, totalVerticalPadding) {
        /* pointSize / 0.75 == pixelSize == roughly the height of "ph|".
         * HACK: pixelSize * 1.21875 == roughly the height of '█'.
         * I got 1.21875 by looking at "█ph|" (96pt Noto Sans), counting the heights in pixels
         * and then dividing the block height by the pixel size of the text.
         */
        return Math.max(iconHeight, units.estimatedBoundingRectHeight(pointSize)) + totalVerticalPadding;
    }

    function dynamicControlPadding(iconHeight, pointSize) {
        return Math.round(Math.max(iconHeight, units.estimatedBoundingRectHeight(pointSize)) / 2);
    }

    function estimatedBoundingRectHeight(pointSize) {
        return Math.floor(pointSize / 0.75 * 1.3671875);
    }

    function estimatedBlockHeight(pointSize) {
        return Math.floor(pointSize / 0.75 * 1.21875);
    }

    function symbolSize(size) {
        size -= size % 6
        size -= size/3
        return size
    }
    //END Breeze Units

    /**
     * Units.verySmallSpacing is the amount of spacing that should be used around smaller UI elements,
     * for example as spacing in Columns. Internally, this size depends on the size of
     * the default font as rendered on the screen, so it takes user-configured font size and DPI
     * into account.
     */
    property int verySmallSpacing: 2

    /**
     * Units.smallSpacing is the amount of spacing that should be used around smaller UI elements,
     * for example as spacing in Columns. Internally, this size depends on the size of
     * the default font as rendered on the screen, so it takes user-configured font size and DPI
     * into account.
     */
    property int smallSpacing: 4

    /**
     * Units.mediumSpacing is the amount of spacing that should be used around medium UI elements
     */
    property int mediumSpacing: 6

    /**
     * Units.largeSpacing is the amount of spacing that should be used inside bigger UI elements,
     * for example between an icon and the corresponding text. Internally, this size depends on
     * the size of the default font as rendered on the screen, so it takes user-configured font
     * size and DPI into account.
     */
    property int largeSpacing: 8

    /**
     * Units.veryLargeSpacing is the amount of spacing that should be used inside very big UI elements
     */
    property int veryLargeSpacing: 12

    /**
     * The ratio between physical and device-independent pixels. This value does not depend on the \
     * size of the configured font. If you want to take font sizes into account when scaling elements,
     * use theme.mSize(theme.defaultFont), units.smallSpacing and units.largeSpacing.
     * The devicePixelRatio follows the definition of "device independent pixel" by Microsoft.
     */
    property real devicePixelRatio: Math.max(1, (fontMetrics.font.pixelSize*0.75) / fontMetrics.font.pointSize)

    /**
     * units.shortDuration should be used for short animations, such as accentuating a UI event,
     * hover events, etc..
     */
    property int veryShortDuration: 50

    /**
     * units.shortDuration should be used for short animations, such as accentuating a UI event,
     * hover events, etc..
     */
    property int shortDuration: 100
    
    /**
     * units.shortDuration should be used for short animations, such as accentuating a UI event,
     * hover events, etc..
     */
    property int mediumDuration: 150

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
     * Time in milliseconds equivalent to the theoretical human moment, which can be used
     * to determine whether how long to wait until the user should be informed of something,
     * or can be used as the limit for how long something should wait before being
     * automatically initiated.
     *
     * Some examples:
     *
     * - When the user types text in a search field, wait no longer than this duration after
     *   the user completes typing before starting the search
     * - When loading data which would commonly arrive rapidly enough to not require interaction,
     *   wait this long before showing a spinner
     *
     * This might seem an arbitrary number, but given the psychological effect that three
     * seconds seems to be what humans consider a moment (and in the case of waiting for
     * something to happen, a moment is that time when you think "this is taking a bit long,
     * isn't it?"), the idea is to postpone for just before such a conceptual moment. The reason
     * for the two seconds, rather than three, is to function as a middle ground: Not long enough
     * that the user would think that something has taken too long, for also not so fast as to
     * happen too soon.
     *
     * See also
     * https://www.psychologytoday.com/blog/all-about-addiction/201101/tick-tock-tick-hugs-and-life-in-3-second-intervals
     * (the actual paper is hidden behind an academic paywall and consequently not readily
     * available to us, so the source will have to be the blog entry above)
     *
     * \note This should __not__ be used as an animation duration, as it is deliberately not scaled according
     * to the animation settings. This is specifically for determining when something has taken too long and
     * the user should expect some kind of feedback. See veryShortDuration, shortDuration, longDuration, and
     * veryLongDuration for animation duration choices.
     *
     * @since 5.81
     * @since org.kde.kirigami 2.16
     */
    property int humanMoment: 2000

    /**
     * How much the mouse scroll wheel scrolls, expressed in lines of text.
     * Note: this is strictly for classical mouse wheels, touchpads 2 figer scrolling won't be affected
     */
    readonly property int wheelScrollLines: 3

    /**
     * metrics used by the default font
     */
    property var fontMetrics: FontMetrics {
        /* Height of a flat topped capital letter
         * 
         * QFontEngine (private, used by QFontMetricsF) uses an 'H' to
         * calculate capHeight(), so the behavior should match the behavior
         * of QFontMetricsF::capHeight().
         * NOTE: With FreeType, QFontMetricsF::capHeight() is just an alias to QFontMetricsF::ascent()
         * 
         * WARNING: Very Latin-centric. Be kind to your translators and use it
         * carefully. Don't make areas with text that are too small to look
         * good with or at least contain scripts that aren't based on Latin.
         * Examples of scripts to check: CJK, Arabic, Devanagari, Malayalam
         */
        property real flatCapHeight: fontMetrics.tightBoundingRect("ETIFHL").height

        /// Height of a full block character
        property real blockHeight: fontMetrics.tightBoundingRect('█').height

        property real verticalBarHeight: fontMetrics.tightBoundingRect('|').height
        
        /* Can be used to guess the font's stroke width.
         * It's not always exactly the same as letter stroke widths.
         * In fonts where 'l' is just a straight line, 'l' is more accurate,
         * but 'l' isn't always just a straight line.
         */
        property real verticalBarWidth: fontMetrics.tightBoundingRect('|').width

        property real emWidth: fontMetrics.boundingRect('M').width
        property real fullWidthCharWidth: fontMetrics.tightBoundingRect('＿').width

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

    property real pixelSizeBoundingRectHeightRatio: __boundingRectRatioFontMetrics.font.pixelSize / __boundingRectRatioFontMetrics.height

    property var __boundingRectRatioFontMetrics: FontMetrics {
        font.pointSize: 96
    }
}
