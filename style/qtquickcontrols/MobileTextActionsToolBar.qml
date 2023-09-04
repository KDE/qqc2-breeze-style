/* SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

Loader {
    id: root
    property Item target
    visible: Kirigami.Settings.tabletMode && target.selectedText.length > 0
    active: visible
    sourceComponent: Popup {
        id: popup

        property real xAlignHCenter: Math.round(Qt.inputMethod.anchorRectangle.x + (Qt.inputMethod.cursorRectangle.x - Qt.inputMethod.anchorRectangle.x - width)/2)
        property real yAlignOver: Math.round(Qt.inputMethod.anchorRectangle.y - height - fontMetrics.descent)

        visible: false
        parent: Overlay.overlay
        modal: false
        focus: false
        margins: Impl.Units.verySmallSpacing
        padding: 0

        x: xAlignHCenter
        y: yAlignOver

        // HACK: make it appear above most popups that show up in the
        // overlay in case any of them use TextField or TextArea
        z: 999

        contentItem: RowLayout {
            spacing: 0
            ToolButton {
                focusPolicy: Qt.NoFocus
                icon.name: "edit-cut"
                visible: target && target.selectedText.length > 0 && (!target.hasOwnProperty("echoMode") || target.echoMode === TextInput.Normal)
                onClicked: {
                    target.cut();
                }
            }
            ToolButton {
                focusPolicy: Qt.NoFocus
                icon.name: "edit-copy"
                visible: target && target.selectedText.length > 0 && (!target.hasOwnProperty("echoMode") || target.echoMode === TextInput.Normal)
                onClicked: {
                    target.copy();
                }
            }
            ToolButton {
                focusPolicy: Qt.NoFocus
                icon.name: "edit-paste"
                visible: target && target.canPaste
                onClicked: {
                    target.paste();
                }
            }
        }

        FontMetrics {
            id: fontMetrics
            font: target.font
        }
    }
}

