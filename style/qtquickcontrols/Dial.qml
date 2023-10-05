/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQml
import QtQuick.Controls as Controls
import QtQuick.Controls.impl
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.breeze
import org.kde.breeze.impl as Impl

T.Dial {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    inputMode: !Kirigami.Settings.tabletMode ? Dial.Vertical : Dial.Circular

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    background: Impl.BreezeDial {
        implicitWidth: 100
        implicitHeight: 100
        backgroundBorderColor: Kirigami.Theme.separatorColor
        backgroundColor: Kirigami.Theme.backgroundColor
        fillBorderColor: Kirigami.Theme.focusColor
        fillColor: Kirigami.Theme.alternateBackgroundColor
        angle: control.angle
        grooveThickness: Impl.Units.grooveHeight
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
        property real grooveOffset: Impl.Units.grooveHeight * 4
        x: control.background.x + (control.background.width - control.handle.width) / 2
        y: control.background.y + (control.background.height - control.handle.height) / 2
        implicitWidth: implicitHeight
        implicitHeight: 100 - grooveOffset + 2
        width: height
        height: {
            let bgExtent = Math.min(control.background.width, control.background.height)
            let handleExtent = bgExtent
            if (bgExtent - grooveOffset <= grooveOffset*2) {
                handleExtent -= grooveOffset/2 - 2
            } else {
                handleExtent -= grooveOffset - 2
            }
            return handleExtent
        }
        radius: height/2

        color: Kirigami.Theme.backgroundColor

        border {
            width: Impl.Units.smallBorder
            color: control.hovered || control.pressed || control.visualFocus
                ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
        }

        shadow {
            color: control.pressed ? "transparent" : Qt.rgba(0,0,0,0.2)
            size: control.enabled ? Math.round(handle.height/10 + 1) : 0
            yOffset: Math.round(Math.round(handle.height/10 + 1) / 4)
        }

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
                id: handleDot
                radius: width/2
                anchors.verticalCenter: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: height
                width: 4
                height: 4
                color: control.enabled ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
            }
        }

        Behavior on border.color {
            enabled: control.hovered || control.pressed || control.visualFocus
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

        Impl.FocusRect {
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
