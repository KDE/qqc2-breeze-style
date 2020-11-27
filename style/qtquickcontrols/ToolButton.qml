/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.ToolButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    flat: true

    Kirigami.Theme.colorSet: control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button
    Kirigami.Theme.inherit: control.flat && !control.down && !control.checked
// NOTE: For some reason, Kirigami apps override the colorSet even when inherit == false
//     property int colorSet: Kirigami.Theme.colorSet
//     onColorSetChanged: {
//         console.log("colorSet: " + Kirigami.Theme.colorSet)
//         colorSet = Qt.binding(() => control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button)
//         Kirigami.Theme.colorSet = Qt.binding(() =>colorSet)
//     }
//     property bool inherit: Kirigami.Theme.inherit
//     onInheritChanged: {
//         console.log("inherit: " + Kirigami.Theme.inherit)
//         inherit = Qt.binding(() => control.flat && !(control.down || control.checked))
//         Kirigami.Theme.inherit = Qt.binding(() => inherit)
//     }

    padding: Kirigami.Units.mediumSpacing
    horizontalPadding: Kirigami.Units.mediumHorizontalPadding
    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto

    Kirigami.MnemonicData.enabled: control.enabled && control.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: control.display !== T.Button.IconOnly ? control.text : ""
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(control.text))
        sequence: control.Kirigami.MnemonicData.sequence
        onActivated: control.clicked()
    }

    contentItem: IconLabelContent {
        control: control
        text: control.Kirigami.MnemonicData.richTextLabel
    }

    background: ButtonBackground {
        control: control
    }
}
