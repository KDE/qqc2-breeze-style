/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.breeze.impl as Impl

/* NOTE:
 * It took a LOT of trial and error to get the text to fit in a specific
 * area and also to get the background to fit the text. If you're trying
 * to figure out how to do the same thing, please copy what I did so
 * that you don't have to experience the same amount of pain.
 *  - Noah Davis
 */

T.ToolTip {
    id: control

    // 180pt | 2.5in | 63.5mm
    // This value is basically arbitrary. It just looks nice.
    property real __preferredWidth: Screen.pixelDensity * 63.5 * Screen.devicePixelRatio

    contentWidth: {
        // Always ceil text widths since they're usually not integers.
        // Using round or floor can cause text to wrap or elide.
        let implicitContentOrFirstChildWidth = Math.ceil(implicitContentWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0))

        /* HACK: Adding 1 prevents the right side from sometimes having an
         * unnecessary amount of padding. This could fail to fix the issue
         * in some contexts, but it seems to work with Noto Sans at 10pts,
         * 10.5pts and 11pts.
         */
        // If contentWidthSource isn't available, cWidth = 0
        let cWidth = Math.ceil(contentWidthSource.contentWidth ?? -1) + 1
        return cWidth > 0 ? cWidth : implicitContentOrFirstChildWidth
    }

    // palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
    Kirigami.Theme.inherit: false

    x: parent ? Math.round((parent.width - implicitWidth) / 2) : 0
    y: -implicitHeight - Kirigami.Units.smallSpacing
    // Always show the tooltip on top of everything else
    z: 999

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.mediumSpacing
    horizontalPadding: Impl.Units.mediumHorizontalPadding

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    delay: Kirigami.Units.toolTipDelay

    enter: Transition {
        OpacityAnimator {
            from: 0
            to: 1
            easing.type: Easing.OutCubic
            duration: Kirigami.Units.shortDuration
        }
    }

    exit: Transition {
        OpacityAnimator {
            from: 1
            to: 0
            easing.type: Easing.InCubic
            duration: Kirigami.Units.shortDuration
        }
    }

    contentItem: Label {
        text: control.text
        font: control.font
        wrapMode: Text.WordWrap

        // This code looks ugly, but I can't think of anything less ugly
        // that is just as reliable. TextMetrics doesn't support WordWrap.
        Text {
            id: contentWidthSource
            visible: false
            width: control.__preferredWidth
            text: parent.text
            font: parent.font
            wrapMode: parent.wrapMode
            renderType: parent.renderType
            horizontalAlignment: parent.horizontalAlignment
            verticalAlignment: parent.verticalAlignment
            elide: parent.elide
            fontSizeMode: parent.fontSizeMode
            lineHeight: parent.lineHeight
            lineHeightMode: parent.lineHeightMode
            // Make the 1st line the longest to make text alignment a bit prettier.
            maximumLineCount: 1
            minimumPixelSize: parent.minimumPixelSize
            minimumPointSize: parent.minimumPointSize
            style: parent.style
            textFormat: parent.textFormat
        }
    }

    background: Impl.StandardRectangle {
        implicitWidth: implicitHeight
        implicitHeight: Impl.Units.mediumControlHeight
        radius: Impl.Units.smallRadius
        color: Kirigami.Theme.backgroundColor
        border.width: Impl.Units.smallBorder
        border.color: Impl.Theme.separatorColor()

        Impl.LargeShadow {
            radius: parent.radius
        }
    }

    T.Overlay.modal: Impl.OverlayModalBackground {}
    T.Overlay.modeless: Impl.OverlayDimBackground {}
}
