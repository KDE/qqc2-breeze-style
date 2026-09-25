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
        Timer {
            id: blinkTimer
            interval: Application.styleHints.cursorFlashTime / 2
            running: root.visible && interval > 0 && root.target.selectionStart === root.target.selectionEnd
            repeat: true
            onTriggered: cursorLine.opacity = cursorLine.opacity === 1 ? 0 : 1
            onRunningChanged: if (!running) cursorLine.opacity = 1
        }
        Connections {
            target: root.target
            function onCursorPositionChanged() {
                cursorLine.opacity = 1
                blinkTimer.restart()
            }
        }
    }
}

