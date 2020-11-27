/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

T.DialogButtonBox {
    id: control

    readonly property bool isHeader: control.position === T.DialogButtonBox.Header
    readonly property bool isFooter: control.position === T.DialogButtonBox.Footer

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: Kirigami.Units.smallSpacing

    padding: Kirigami.Units.smallSpacing + Kirigami.Units.smallBorder

    property real inset: 0
    property real horizontalInset: inset
    property real verticalInset: inset
    leftInset: horizontalInset
    rightInset: horizontalInset
    topInset: verticalInset
    bottomInset: verticalInset

    alignment: Qt.AlignRight

    delegate: Button {
        width: Math.round(Math.min(implicitWidth, (control.availableWidth / control.count) - (control.spacing * (control.count-1))))
        Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.DialogButton
    }

    contentItem: ListView {
        pixelAligned: true
        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
    }

    background: Kirigami.ShadowedRectangle {
        property real topRadius: control.isHeader ? Kirigami.Units.smallRadius : 0
        property real bottomRadius: control.isFooter ? Kirigami.Units.smallRadius : 0
        border {
            width: Kirigami.Units.smallBorder
            color: Kirigami.Theme.separatorColor
        }
        corners {
            topLeftRadius: topRadius
            topRightRadius: topRadius
            bottomLeftRadius: bottomRadius
            bottomRightRadius: bottomRadius
        }
        // Enough height for Buttons/ComboBoxes/TextFields with smallSpacing padding on top and bottom
        implicitHeight: Kirigami.Units.mediumControlHeight + (Kirigami.Units.smallSpacing * 2) + Kirigami.Units.smallBorder*2 //+ (separator.visible ? 1 : 0) 
        color: Kirigami.Theme.backgroundColor
//         Kirigami.Separator {
//             id: separator
//             color: control.isHeader || control.isFooter ? Kirigami.Theme.separatorColor : Kirigami.Theme.backgroundColor
//             anchors {
//                 left: parent.left
//                 right: parent.right
//                 verticalCenter: control.isHeader ? parent.bottom : parent.top
//             }
//         }
    }
}
