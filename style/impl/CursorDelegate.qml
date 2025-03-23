/* SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window

import "." as Impl

Loader {
    id: root
    required property Item target
    x: Math.floor(target.cursorRectangle.x)
    y: Math.floor(target.cursorRectangle.y)
    active: visible
    sourceComponent: Impl.StandardRectangle {
        id: cursorLine
        implicitWidth: root.target.cursorRectangle.width
        implicitHeight: root.target.cursorRectangle.height
        color: root.target.color
        SequentialAnimation {
            id: blinkAnimation
            running: root.visible && Application.styleHints.cursorFlashTime != 0 && target.selectionStart === target.selectionEnd
            PropertyAction {
                target: cursorLine
                property: "opacity"
                value: 1
            }
            PauseAnimation {
                duration: Application.styleHints.cursorFlashTime/2
            }
            SequentialAnimation {
                loops: Animation.Infinite
                OpacityAnimator {
                    target: cursorLine
                    from: 1
                    to: 0
                    duration: Application.styleHints.cursorFlashTime/2
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    target: cursorLine
                    from: 0
                    to: 1
                    duration: Application.styleHints.cursorFlashTime/2
                    easing.type: Easing.OutCubic
                }
            }
        }
        Connections {
            target: root.target
            function onCursorPositionChanged() {
                blinkAnimation.restart()
            }
        }
    }
}


