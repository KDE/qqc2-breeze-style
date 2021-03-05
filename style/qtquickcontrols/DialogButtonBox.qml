/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

T.DialogButtonBox {
    id: control

    readonly property bool __isHeader: control.position === T.DialogButtonBox.Header
    readonly property bool __isFooter: control.position === T.DialogButtonBox.Footer

    // Children of QML Popup elements and subclasses of Popup are actually
    // children of an internal QQuickPopupItem, a subclass of QQuickPage.
    property bool __isInPopup: parent ? parent.toString().includes("QQuickPopupItem") : false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: Kirigami.Units.smallSpacing

    padding: Kirigami.Units.smallSpacing

    // Add space for the separator above the footer
    topPadding: __isFooter && background && background.hasOwnProperty("separator") ?
        background.separator.height + verticalPadding : verticalPadding
    // Add space for the separator below the header
    bottomPadding: __isHeader && background && background.hasOwnProperty("separator") ?
        background.separator.height + verticalPadding : verticalPadding

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
        property real topRadius: control.__isHeader ? radius : 0
        property real bottomRadius: control.__isFooter ? radius : 0
        radius: control.__isInPopup ? Kirigami.Units.smallRadius : 0
        corners {
            topLeftRadius: topRadius
            topRightRadius: topRadius
            bottomLeftRadius: bottomRadius
            bottomRightRadius: bottomRadius
        }
        // Enough height for Buttons/ComboBoxes/TextFields with smallSpacing padding on top and bottom
        implicitHeight: Kirigami.Units.mediumControlHeight + (Kirigami.Units.smallSpacing * 2) + (separator.visible ? separator.height : 0)
        color: control.__isInPopup ? "transparent" : Kirigami.Theme.backgroundColor
        property Item separator: Kirigami.Separator {
            parent: background
            visible: control.__isHeader || control.__isFooter
            width: parent.width
            y: control.__isFooter ? 0 : parent.height - height
        }
    }
}
