/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.DelayButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    padding: Kirigami.Units.mediumSpacing
    horizontalPadding: Kirigami.Units.mediumHorizontalPadding
    spacing: Kirigami.Units.mediumSpacing

    transition: Transition {
        NumberAnimation {
            duration: control.delay * (control.pressed ? 1.0 - control.progress : 0.3 * control.progress)
        }
    }

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
        color: control.palette.button

        Kirigami.ShadowedRectangle {
            id: progressFillRect
            property real visualProgress: control.mirrored ? 1 - control.progress : control.progress
            property real radiusThreshold: parent.width - leftRadius
            property real leftRadius: Kirigami.Units.smallRadius
            property real rightRadius: width > radiusThreshold ? width - radiusThreshold : 0
            corners {
                topLeftRadius: control.mirrored ? rightRadius : leftRadius
                topRightRadius: control.mirrored ? leftRadius : rightRadius
                bottomLeftRadius: control.mirrored ? rightRadius : leftRadius
                bottomRightRadius: control.mirrored ? leftRadius : rightRadius
            }
            height: parent.height
            x: control.mirrored ? (1 - control.progress) * parent.width : 0
            width: control.progress * parent.width
            color: Kirigami.Theme.alternateBackgroundColor
            border {
                color: Kirigami.Theme.highlightColor
                width: parent.border.width
            }
        }
    }
}
