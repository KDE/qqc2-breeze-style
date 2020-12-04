// NOTE: check this
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
    
    property bool __reserveSpaceForIndicator: true
    property bool __reserveSpaceForIcon: false
    property bool __reserveSpaceForArrow: true

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

//     width: parent ? parent.width : implicitWidth

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto

    Layout.fillWidth: true

    spacing: Kirigami.Units.mediumSpacing
    padding: Kirigami.Units.mediumSpacing
    leftPadding: !contentItem.icon.visible && !control.indicator ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding

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

    indicator: CheckIndicator {
        visible: control.checkable
        control: control
        checkState: control.checked ? Qt.Checked : Qt.Unchecked
    }

    arrow: Kirigami.Icon {
        anchors {
            right: control.right
            rightMargin: control.rightPadding
            verticalCenter: control.verticalCenter
        }
       source: control.mirrored ? "arrow-left" : "arrow-right"
       implicitWidth: Kirigami.Units.iconSizes.auto
       implicitHeight: Kirigami.Units.iconSizes.auto
       visible: control.subMenu
   }

    contentItem: IconLabelShortcutContent {
        control: control
        text: control.Kirigami.MnemonicData.richTextLabel
        alignment: Text.AlignLeft
        reserveSpaceForIndicator: control.__reserveSpaceForIndicator
        reserveSpaceForIcon: control.__reserveSpaceForIcon
        reserveSpaceForArrow: control.__reserveSpaceForArrow
    }

    //background: DelegateBackground {
        //control: control
    //}
}
