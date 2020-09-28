/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.MenuItem {
    id: control

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

//     width: parent ? parent.width : implicitWidth

    icon.width: Kirigami.Units.iconSizes.defaultSize
    icon.height: Kirigami.Units.iconSizes.defaultSize

    Layout.fillWidth: true
    
    spacing: Kirigami.Units.smallSpacing
    padding: Kirigami.Units.smallSpacing
//     leftPadding: Kirigami.Units.largeSpacing
//     rightPadding: Kirigami.Units.largeSpacing
    hoverEnabled: !Kirigami.Settings.isMobile

    Kirigami.MnemonicData.enabled: control.enabled && control.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.MenuItem
    Kirigami.MnemonicData.label: control.text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(control.text))
        sequence: control.Kirigami.MnemonicData.sequence
        onActivated: {
            if (control.checkable) {
                control.toggle();
            } else {
                control.clicked();
            }
        }
    }

    contentItem: RowLayout {
        spacing: control.spacing
        Item {
            //visible: width > 0
            Layout.preferredWidth: (control.ListView.view && control.ListView.view.hasCheckables)
            || (control.checkable && control.indicator) ?
                control.indicator.width : 0
        }
        Kirigami.Icon {
            id: iconContent
            Layout.alignment: Qt.AlignVCenter
            visible: control.icon != undefined && (control.icon.name.length > 0 || control.icon.source.length > 0)
            source: control.icon.name
            color: control.icon.color
            Layout.preferredHeight: control.icon.height > 0 ? control.icon.width : Kirigami.Units.iconSizes.defaultSize
            Layout.preferredWidth: control.icon.width > 0 ? control.icon.width : Kirigami.Units.iconSizes.defaultSize
        }
        Controls.Label {
            id: labelContent
            leftPadding: !iconContent.visible && control.ListView.view && control.ListView.view.hasIcons ? Kirigami.Units.iconSizes.defaultSize + control.spacing : 0
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            text: control.Kirigami.MnemonicData.richTextLabel
            font: control.font
            color: Kirigami.Theme.textColor
            elide: Text.ElideRight
            visible: control.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        Controls.Label {
            id: shortcut
            Layout.alignment: Qt.AlignVCenter
            visible: control.action && control.action.hasOwnProperty("shortcut") && control.action.shortcut !== undefined

            Shortcut {
                id: itemShortcut
                sequence: (shortcut.visible && control.action !== null) ? control.action.shortcut : ""
            }

            text: visible ? itemShortcut.nativeText : ""
            font: control.font
            color: labelContent.color
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
        Item {
            //visible: width > 0
            Layout.preferredWidth: control.subMenu && control.arrow ?
                control.arrow.width : 0
        }
    }

    arrow: Kirigami.Icon {
       x: control.mirrored ? control.padding : control.width - width - control.padding
       y: (control.height - height) / 2
       source: control.mirrored ? "arrow-left" : "arrow-right"
       implicitWidth: Kirigami.Units.iconSizes.defaultSize
       implicitHeight: width
       visible: control.subMenu
   }

    indicator: CheckIndicator {
        visible: control.checkable
        control: control
    }

    //background: DelegateBackground { control: control }
}
