/* SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import QtQuick.Templates
import org.kde.kirigami as Kirigami

import "." as Impl

Loader {
    id: root
    property Item target
    property bool isSelectionEnd: false
    visible: Kirigami.Settings.tabletMode && target.selectByMouse && target.activeFocus && (isSelectionEnd ? target.selectionStart !== target.selectionEnd : true) && Qt.platform.os !== 'android'
    active: visible
    sourceComponent: Kirigami.ShadowedRectangle {
        id: handle
        property real selectionStartX: Math.floor(InputMethod.anchorRectangle.x + (InputMethod.cursorRectangle.width - width)/2)
        property real selectionStartY: Math.floor(InputMethod.anchorRectangle.y + InputMethod.cursorRectangle.height + pointyBitVerticalOffset)
        property real selectionEndX: Math.floor(InputMethod.cursorRectangle.x + (InputMethod.cursorRectangle.width - width)/2)
        property real selectionEndY: Math.floor(InputMethod.cursorRectangle.y + InputMethod.cursorRectangle.height + pointyBitVerticalOffset)
        property real pointyBitVerticalOffset: Math.abs(pointyBit.y*2)
        parent: Overlay.overlay
        x: root.isSelectionEnd ? selectionEndX : selectionStartX
        y: root.isSelectionEnd ? selectionEndY : selectionStartY

        // HACK: make it appear above most popups that show up in the
        // overlay in case any of them use TextField or TextArea
        z: 999

        //opacity: target.activeFocus ? 1 : 0
        implicitHeight: {
            let h = Kirigami.Units.gridUnit
            return h - (h % 2 == 0 ? 1 : 0)
        }
        implicitWidth: implicitHeight
        radius: width/2

        color: root.target.selectionColor

        shadow {
            color: Qt.rgba(0,0,0,0.2)
            size: 3
            yOffset: 1
        }

        Impl.StandardRectangle {
            id: pointyBit
            x: (parent.width - width)/2
            y: -height/4 + 0.2 // magic number to get it to line up with the edge of the circle
            implicitHeight: parent.implicitHeight/2
            implicitWidth: implicitHeight
            antialiasing: true
            rotation: 45
            color: parent.color
        }

        Kirigami.ShadowedRectangle {
            id: inner
            visible: root.root.target.selectionStart !== target.selectionEnd && (handle.y < selectionStartY || handle.y < selectionEndY)
            anchors.fill: parent
            anchors.margins: Impl.Units.smallBorder
            color: root.target.selectedTextColor
            radius: height/2
            Impl.StandardRectangle {
                id: innerPointyBit
                x: (parent.width - width)/2
                y: -height/4 + 0.8 // magic number to get it to line up with the edge of the circle
                implicitHeight: pointyBit.implicitHeight
                implicitWidth: implicitHeight
                antialiasing: true
                rotation: 45
                color: parent.color
            }
        }

        MouseArea {
            enabled: handle.visible
            anchors.fill: parent
    //         preventStealing: true
            onPositionChanged: {
                let pos = mapToItem(root.target, mouse.x, mouse.y);
                pos = root.target.positionAt(pos.x, pos.y - handle.height - handle.pointyBitVerticalOffset);

                if (target.selectionStart !== target.selectionEnd) {
                    if (!isSelectionEnd) {
                        root.target.select(Math.min(pos, root.target.selectionEnd - 1), root.target.selectionEnd);
                    } else {
                        root.target.select(root.target.selectionStart, Math.max(pos, root.target.selectionStart + 1));
                    }
                } else {
                    root.target.cursorPosition = pos;
                }
            }
        }

        // NumberAnimations/SmoothedAnimations appear smoother than X/Y Animators for some reason.
        // The animations feel a bit janky when moving handles while text is selected.
        /*Behavior on x {
            enabled: enableXYAnimations && target.selectionStart === target.selectionEnd
            SmoothedAnimation {
                velocity: 200
                reversingMode: SmoothedAnimation.Immediate
                duration: Kirigami.Units.shortDuration
            }
        }
        Behavior on y {
            enabled: enableXYAnimations && target.selectionStart === target.selectionEnd
            SmoothedAnimation {
                velocity: 200
                reversingMode: SmoothedAnimation.Immediate
                duration: Kirigami.Units.shortDuration
            }
        }

        //HACK
        property bool enableXYAnimations: false
        Timer {
            id: animationHackTimer
            running: true
            interval: 1
            onTriggered: handle.enableXYAnimations = true
        }
        */
    }
}
