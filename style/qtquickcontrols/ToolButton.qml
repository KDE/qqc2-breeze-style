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
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    flat: true

    Kirigami.Theme.colorSet: /*control.highlighted ? Kirigami.Theme.Selection :*/ Kirigami.Theme.Button
    Kirigami.Theme.inherit: false//control.flat && !control.down && !control.checked
    // Absolutely terrible HACK:
    // For some reason, ActionToolBar overrides the colorSet and inherit attached properties
    Component.onCompleted: {
        //console.log("colorSet: " + Kirigami.Theme.colorSet)
        //console.log("inherit: " + Kirigami.Theme.inherit)
        Kirigami.Theme.colorSet = Kirigami.Theme.Button/*Qt.binding(() => control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button)*/
        Kirigami.Theme.inherit = false//Qt.binding(() => control.flat && !(control.down || control.checked))
    }

    padding: Kirigami.Units.mediumSpacing
    leftPadding: !contentItem.iconVisible && !control.indicator ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding
    rightPadding: contentItem.labelVisible ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding

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
