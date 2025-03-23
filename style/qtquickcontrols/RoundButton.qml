//NOTE: change this
/*
    SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.breeze.impl as Impl

T.RoundButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    baselineOffset: contentItem.y + contentItem.baselineOffset

    // palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button
    Kirigami.Theme.inherit: control.flat && !control.down && !control.checked

    padding: Kirigami.Units.mediumSpacing
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

    contentItem:Impl.IconLabelContent {
        control: control
        text: control.Kirigami.MnemonicData.richTextLabel
    }

    background: Impl.ButtonBackground {
        control: control
        radius: control.radius
    }
}
