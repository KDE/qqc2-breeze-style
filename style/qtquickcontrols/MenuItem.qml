/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl" as Impl

T.MenuItem {
    id: control

    property bool __reserveSpaceForIndicator: {
        if (menu && menu.hasOwnProperty("__hasIndicators")) {
            menu.__hasIndicators |= indicator && indicator.visible
            return menu.__hasIndicators
        }
        return false
    }
    property bool __reserveSpaceForIcon: {
        if (menu && menu.hasOwnProperty("__hasIcons")) {
            menu.__hasIcons |= contentItem && contentItem.hasIcon
            return menu.__hasIcons
        }
        return false
    }
    property bool __reserveSpaceForArrow: {
        if (menu && menu.hasOwnProperty("__hasArrows")) {
            menu.__hasArrows |= arrow && arrow.visible
            return menu.__hasArrows
        }
        return false
    }

    Kirigami.Theme.colorSet: control.down || control.highlighted ? Kirigami.Theme.Button : -1
    Kirigami.Theme.inherit: !background || !background.visible && !(control.highlighted || control.down)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

//     width: parent ? parent.width : implicitWidth

    icon.width: Impl.Units.iconSizes.auto
    icon.height: Impl.Units.iconSizes.auto

    Layout.fillWidth: true

    spacing: Impl.Units.mediumSpacing
    padding: Impl.Units.mediumSpacing
    leftPadding: {
        if (!control.indicator.visible
            && ((!contentItem.hasIcon && contentItem.textBesideIcon) // False if contentItem has been replaced
                || display == T.AbstractButton.TextOnly
                || display == T.AbstractButton.TextUnderIcon)) {
            return Impl.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    rightPadding: {
        if (!control.arrow.visible
            && contentItem.hasLabel // False if contentItem has been replaced
            && display != T.AbstractButton.IconOnly) {
            return Impl.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }

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

    indicator: Impl.CheckIndicator {
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
        implicitWidth: Impl.Units.iconSizes.auto
        implicitHeight: Impl.Units.iconSizes.auto
        visible: control.subMenu
    }

    contentItem: Impl.IconLabelShortcutContent {
        control: control
        text: control.Kirigami.MnemonicData.richTextLabel
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        reserveSpaceForIndicator: control.__reserveSpaceForIndicator
        reserveSpaceForIcon: control.__reserveSpaceForIcon
        reserveSpaceForArrow: control.__reserveSpaceForArrow
    }

    background: Impl.MenuItemBackground {
        control: control
    }
}
