/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

T.Button {
    id: control

    implicitWidth: {
        let contentAndPaddingWidth = implicitContentWidth + leftPadding + rightPadding;
        const minimumTextButtonWidth = Kirigami.Units.iconSizes.sizeForLabels * 5;

        // To match qqc2-desktop-style behavior, we enforce a minimum width for Buttons that have text
        if (display !== AbstractButton.IconOnly && text !== "") {
            contentAndPaddingWidth = Math.max(contentAndPaddingWidth, minimumTextButtonWidth);
        }

        Math.max(implicitBackgroundWidth + leftInset + rightInset,
                 contentAndPaddingWidth,
                 implicitIndicatorWidth + leftPadding + rightPadding)
    }
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    flat: false

    // // palette: Kirigami.Theme.palette

    hoverEnabled: Qt.styleHints.useHoverEffects

    Kirigami.Theme.colorSet: /*control.highlighted ? Kirigami.Theme.Selection :*/ Kirigami.Theme.Button
    Kirigami.Theme.inherit: false//control.flat && !control.down && !control.checked

    padding: Kirigami.Units.largeSpacing
    leftPadding: {
        if ((!contentItem.hasIcon && contentItem.textBesideIcon) // False if contentItem has been replaced
            || display == T.AbstractButton.TextOnly
            || display == T.AbstractButton.TextUnderIcon) {
            return Impl.Units.largeHorizontalPadding;
        }
        return control.horizontalPadding;
    }
    rightPadding: {
        if (contentItem.hasLabel && display != T.AbstractButton.IconOnly) { // False if contentItem has been replaced
            return Impl.Units.largeHorizontalPadding;
        }
        return control.horizontalPadding;
    }

    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.sizeForLabels
    icon.height: Kirigami.Units.iconSizes.sizeForLabels

    Kirigami.MnemonicData.enabled: control.enabled && control.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: control.display !== T.Button.IconOnly ? control.text : ""
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(control.text))
        sequence: control.Kirigami.MnemonicData.sequence
        onActivated: control.clicked()
    }

    contentItem: Impl.IconLabelContent {
        control: control
        text: control.Kirigami.MnemonicData.richTextLabel
    }

    background: Impl.ButtonBackground {
        control: control
    }
}
