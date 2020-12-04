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
    leftPadding: !contentItem.icon.visible && !control.indicator ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding
    rightPadding: contentItem.label.visible ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding

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
            property real radiusThreshold: parent.width - leftRadius
            property real leftRadius: Kirigami.Units.smallRadius
            property real rightRadius: width > radiusThreshold ? width - radiusThreshold : 0

            visible: width > 0

            corners {
                topLeftRadius: control.mirrored ? rightRadius : leftRadius
                topRightRadius: control.mirrored ? leftRadius : rightRadius
                bottomLeftRadius: control.mirrored ? rightRadius : leftRadius
                bottomRightRadius: control.mirrored ? leftRadius : rightRadius
            }

            x: control.mirrored ? (1 - control.progress) * parent.width : 0
            width: control.progress * parent.width

            y: 0//leftRadius
            height: background.height//parent.height - leftRadius*2

            color: Kirigami.Theme.alternateBackgroundColor
            border {
                color: Kirigami.Theme.highlightColor
                width: parent.border.width
            }

            /* FIXME: this doesn't perfectly scale the height to the background outline.
             * I think it's an issue with ShadowedRectangle.
             * Hopefully nobody notices.
             */
            states: [
                State {
                    name: "normalHeight"
                    when: progressFillRect.width >= progressFillRect.leftRadius
                    PropertyChanges {
                        target: progressFillRect
                        y: 0
                        height: background.height
                    }
                },
                State {
                    name: "reducedHeight"
                    when: progressFillRect.width < progressFillRect.leftRadius
                    PropertyChanges {
                        target: progressFillRect
                        y: progressFillRect.leftRadius/2
                        height: background.height - progressFillRect.leftRadius
                    }
                }
            ]
            
            transitions: Transition {
                from: "*"
                to: "normalHeight"
                NumberAnimation {
                    property: "height"
                    duration: control.delay * (progressFillRect.leftRadius/background.width)
                }
                YAnimator {
                    duration: control.delay * (progressFillRect.leftRadius/background.width)
                }
            }
        }
    }
}
