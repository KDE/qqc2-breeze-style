/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

import "impl" as Impl

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    flat: false

    palette: Kirigami.Theme.palette

    hoverEnabled: Qt.styleHints.useHoverEffects

    Kirigami.Theme.colorSet: /*control.highlighted ? Kirigami.Theme.Selection :*/ Kirigami.Theme.Button
    Kirigami.Theme.inherit: false//control.flat && !control.down && !control.checked
    // Absolutely terrible HACK:
    // For some reason, ActionToolBar overrides the colorSet and inherit attached properties
    Component.onCompleted: {
        Kirigami.Theme.colorSet = Kirigami.Theme.Button/*Qt.binding(() => control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button)*/
        Kirigami.Theme.inherit = false//Qt.binding(() => control.flat && !(control.down || control.checked))
    }

    padding: Impl.Units.mediumSpacing
    leftPadding: {
        if ((!contentItem.hasIcon && contentItem.textBesideIcon) // False if contentItem has been replaced
            || display == T.AbstractButton.TextOnly
            || display == T.AbstractButton.TextUnderIcon) {
            return Impl.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    rightPadding: {
        if (contentItem.hasLabel && display != T.AbstractButton.IconOnly) { // False if contentItem has been replaced
            return Impl.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }

    spacing: Impl.Units.mediumSpacing

    icon.width: Impl.Units.iconSizes.auto
    icon.height: Impl.Units.iconSizes.auto

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
