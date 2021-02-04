/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import org.kde.quickcharts 1.0 as Charts

T.BusyIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    hoverEnabled: false

    padding: Kirigami.Units.mediumSpacing

    ListModel {
        id: pieModel
        dynamicRoles: true

        property color oddColor: Kirigami.Theme.focusColor
        property color evenColor: "transparent"

        // The ends periodically appear to connect,
        // forming a six sided asterisk-like shape with no center area

        Component.onCompleted: {
            append({ value: 1, color: oddColor })
            append({ value: 2, color: evenColor })
            append({ value: 2, color: oddColor })
            append({ value: 2, color: evenColor })
            append({ value: 2, color: oddColor })
            append({ value: 2, color: evenColor })
            append({ value: 2, color: oddColor })
            append({ value: 2, color: evenColor })
            append({ value: 2, color: oddColor })
            append({ value: 2, color: evenColor })
            append({ value: 2, color: oddColor })
            append({ value: 2, color: evenColor })
            append({ value: 1, color: oddColor })
        }
    }

    contentItem: Loader {
        sourceComponent: Kirigami.Theme.lowPowerHardware || GraphicsInfo.api == GraphicsInfo.Software ?
            lowPowerSpinnerComponent : fancySpinnerComponent
    }

    Component {
        id: lowPowerSpinnerComponent
        Kirigami.Icon {
            id: lowPowerSpinner
            implicitWidth: Kirigami.Units.iconSizes.auto
            implicitHeight: Kirigami.Units.iconSizes.auto
            source: "view-refresh"

            opacity: control.visible && control.enabled && control.running ? 1 : 0
            Behavior on opacity {
                OpacityAnimator { duration: Kirigami.Units.shortDuration }
            }

            smooth: true
            RotationAnimator {
                target: lowPowerSpinner
                running: control.visible && control.enabled && control.running
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1500
            }
        }
    }

    Component {
        id: fancySpinnerComponent
        Charts.PieChart {
            id: fancySpinner
            implicitWidth: Kirigami.Units.gridUnit
            implicitHeight: Kirigami.Units.gridUnit

            opacity: control.visible && control.enabled && control.running ? 1 : 0
            Behavior on opacity {
                OpacityAnimator { duration: Kirigami.Units.shortDuration }
            }

            valueSources: Charts.ModelSource { roleName: "value"; model: pieModel }
            colorSource: Charts.ModelSource { roleName: "color"; model: pieModel }

            fromAngle: 0
            toAngle: 360
            thickness: Math.max(Kirigami.Units.smallRadius * 2, Math.floor(Math.min(width, height)/6))
            filled: false
            //smoothEnds: true // Turns the segments into aesthetically pleasing round dots, but breaks the connected appearance when the ends meet :(

            ParallelAnimation {
                running: control.visible && control.enabled && control.running
                SequentialAnimation {
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: fancySpinner
                        property: "toAngle"
                        from: 0
                        to: 360
                        duration: 1000
                    }
                    PauseAnimation {
                        duration: 1000
                    }
                    NumberAnimation {
                        target: fancySpinner
                        property: "fromAngle"
                        from: 0
                        to: 360
                        duration: 1000
                    }
                    PropertyAction {
                        target: fancySpinner
                        properties: "fromAngle,toAngle"
                        value: 0
                    }
                }
                SequentialAnimation {
                    loops: Animation.Infinite
                    RotationAnimator {
                        target: fancySpinner
                        from: 0
                        to: 30
                        duration: 1000
                    }
                    // This is meant to appear to rotate at the same rate as the other 2 animations.
                    // In order to achieve this, the actual rotation rate has to be much higher than the other 2 animimations.
                    // This is because the pie angles aren't being animated while this animation is running.
                    RotationAnimator {
                        target: fancySpinner
                        from: 30
                        to: 330
                        duration: 1000
                    }
                    RotationAnimator {
                        target: fancySpinner
                        from: 330
                        to: 360
                        duration: 1000
                    }
                }
            }
        }
    }
}
