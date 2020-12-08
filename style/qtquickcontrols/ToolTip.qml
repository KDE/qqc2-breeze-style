/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

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
        // If paintedWidthSource isn't available, paintedWidth = 0
        let paintedWidth = Math.ceil(paintedWidthSource.paintedWidth ?? -1) + 1 
        return paintedWidth > 0 ? paintedWidth : implicitContentOrFirstChildWidth
    }

    palette: Kirigami.Theme.palette
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
    horizontalPadding: Kirigami.Units.mediumHorizontalPadding

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutQuad; duration: 100 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.InQuad; duration: 100 }
    }

    contentItem: Controls.Label {
        text: control.text
        font: control.font
        wrapMode: Text.WordWrap

        // This code looks ugly, but I can't think of anything less ugly
        // that is just as reliable. TextMetrics doesn't support WordWrap.
        Text {
            id: paintedWidthSource
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

    background: Rectangle {
        implicitWidth: implicitHeight
        implicitHeight: Kirigami.Units.mediumControlHeight
        radius: Kirigami.Units.smallRadius
        color: Kirigami.Theme.backgroundColor
        border.width: Kirigami.Units.smallBorder
        border.color: Kirigami.Theme.separatorColor

        MediumShadow {
            radius: parent.radius
        }
    }
}
