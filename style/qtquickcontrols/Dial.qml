/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import org.kde.breeze 1.0
import "impl"

T.Dial {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    wrap: true

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    background: BreezeDial {
        implicitWidth: 100
        implicitHeight: 100
        backgroundBorderColor: Kirigami.Theme.separatorColor
        backgroundColor: Kirigami.Theme.backgroundColor
        fillBorderColor: Kirigami.Theme.focusColor
        fillColor: Kirigami.Theme.alternateBackgroundColor
        angle: control.angle
        grooveThickness: Kirigami.Units.grooveHeight
        Behavior on angle {
            enabled: !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: 800
                //SmoothedAnimations have a hardcoded InOutQuad easing
            }
        }
    }

    handle: Kirigami.ShadowedRectangle {
        id: handle
        x: control.background.x + (control.background.width - control.handle.width) / 2
        y: control.background.y + (control.background.height - control.handle.height) / 2
        implicitWidth: implicitHeight
        implicitHeight: 100 - Kirigami.Units.grooveHeight * 4 + 4
        width: height
        height: Math.min(control.background.width, control.background.height) - Kirigami.Units.grooveHeight * 4 + 4
        radius: height/2

        color: Kirigami.Theme.backgroundColor

        border {
            width: Kirigami.Units.smallBorder
            color: control.pressed || control.visualFocus || control.hovered
                ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
        }

        shadow {
            color: control.pressed ? "transparent" : Qt.rgba(0,0,0,0.2)
            size: control.enabled ? 9 : 0
            yOffset: 2
        }

        //opacity: control.enabled ? 1 : 0.3
        Kirigami.ShadowedRectangle {
            anchors.fill: parent
            anchors.margins: parent.border.width
            color: parent.color
            radius: height/2
            rotation: control.angle
            Behavior on rotation {
                enabled: !Kirigami.Settings.hasTransientTouchInput
                SmoothedAnimation {
                    duration: Kirigami.Units.longDuration
                    velocity: 800
                    //SmoothedAnimations have a hardcoded InOutQuad easing
                }
            }
            Rectangle {
                id: handleTriangle
                property real colorPosition: Math.abs(control.angle) / 140
                z: -1
                implicitWidth: Kirigami.Units.gridUnit + Kirigami.Units.grooveHeight
                implicitHeight: Kirigami.Units.gridUnit + Kirigami.Units.grooveHeight
                anchors.verticalCenter: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: height/6
                rotation: 45
                antialiasing: true
                color: control.pressed || control.hovered || !control.enabled
                    ? parent.color
                    : KColorUtils.mix(topColor(parent.color), bottomColor(parent.color), colorPosition)
                border.color: control.pressed || control.hovered || !control.enabled
                    ? handle.border.color
                    : KColorUtils.mix(topColor(handle.border.color), bottomColor(handle.border.color), colorPosition)
                border.width: handle.border.width
                Behavior on color {
                    enabled: control.pressed || control.visualFocus || control.hovered
                    ColorAnimation {
                        duration: Kirigami.Units.shortDuration
                        easing.type: Easing.OutCubic
                    }
                }
                function topColor(color) {
                    return Qt.tint(color, Qt.rgba(1,1,1,0.03125))
                }
                function bottomColor(color) {
                    return Qt.tint(color, Qt.rgba(0,0,0,0.0625))
                }
            }
            Rectangle {
                id: handleDot
                radius: width/2
                anchors.verticalCenter: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: 4
                height: 4
                color: control.enabled ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
            }
        }

        Behavior on border.color {
            enabled: control.pressed || control.visualFocus || control.hovered
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on shadow.color {
            enabled: control.pressed
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutCubic
            }
        }

        FocusRect {
            z: -1
            baseRadius: parent.radius
            visible: control.visualFocus
        }

        Rectangle {
            radius: parent.radius
            opacity: control.pressed || control.hovered ? 0 : 1
            visible: control.enabled
            anchors.fill: parent
            anchors.margins: parent.border.width
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: Qt.rgba(1,1,1,0.03125)
                }
                GradientStop {
                    position: 1
                    color: Qt.rgba(0,0,0,0.0625)
                }
            }
            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
