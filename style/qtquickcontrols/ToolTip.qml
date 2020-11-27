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
 * It took a LOT of trial and error to get the text to fit
 * within 6cm and also to get the background to fit the text.
 * If you're trying to figure out how to do the same thing,
 * please copy what I did with the Layout and the inset
 * so that you don't have to experience the same amount of pain.
 *  - Noah Davis
 */

T.ToolTip {
    id: control

    contentWidth: Math.ceil(
        Math.min(
            paintedWidthSource.paintedWidth,
            implicitContentWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
        )
    )

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
        rightPadding: -1// HACK to prevent the right side from sometimes having an unnecessary amount of padding
        // This code looks ugly, but I can't think of anything less ugly that is just as reliable.
        Text {
            id: paintedWidthSource
            visible: false
            width: Screen.pixelDensity * 63.5 * Screen.devicePixelRatio // 180pt | 2.5in | 63.5mm
            text: contentItem.text
            font: contentItem.font
            wrapMode: contentItem.wrapMode
            renderType: contentItem.renderType
        }
    }

    background: Rectangle {
        implicitWidth: implicitHeight
        implicitHeight: Kirigami.Units.mediumControlHeight
        radius: Kirigami.Units.smallRadius
        color: Kirigami.Theme.backgroundColor
        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip

        MediumShadow {
            radius: parent.radius
        }

        border.width: 1
        border.color: Kirigami.Theme.separatorColor
    }

//     TextMetrics {
//         id: textMetrics
//         text: control.text
//         font: control.font
//     }

    //Behavior on horizontalPadding {
        //NumberAnimation { easing.type: Easing.OutQuad; duration: 100 }
    //}
}
