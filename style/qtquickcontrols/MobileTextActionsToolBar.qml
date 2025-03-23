/* SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

Loader {
    id: root
    property Item target
    visible: Kirigami.Settings.tabletMode && target.selectByMouse && target.selectedText.length > 0
    active: visible
    sourceComponent: Popup {
        id: popup

        property real xAlignHCenter: Math.round(InputMethod.anchorRectangle.x + (InputMethod.cursorRectangle.x - InputMethod.anchorRectangle.x - width)/2)
        property real yAlignOver: Math.round(InputMethod.anchorRectangle.y - height - fontMetrics.descent)

        visible: false
        parent: T.Overlay.overlay
        modal: false
        focus: false
        margins: Impl.Units.verySmallSpacing
        padding: Kirigami.Units.smallSpacing

        x: xAlignHCenter
        y: yAlignOver

        // HACK: make it appear above most popups that show up in the
        // overlay in case any of them use TextField or TextArea
        z: 999

        contentItem: RowLayout {
            spacing: Kirigami.Units.smallSpacing

            ToolButton {
                focusPolicy: Qt.NoFocus
                icon.name: "edit-cut"
                text: qsTr("Cut", "@action:inmenu Text editor action")
                visible: root.target && root.target.selectedText.length > 0 && (!root.target.hasOwnProperty("echoMode") || root.target.echoMode === TextInput.Normal)
                onClicked: root.target.cut();
            }

            ToolButton {
                focusPolicy: Qt.NoFocus
                icon.name: "edit-copy"
                text: qsTr("Copy", "@action:inmenu Text editor action")
                visible: root.target && root.target.selectedText.length > 0 && (!root.target.hasOwnProperty("echoMode") || root.target.echoMode === TextInput.Normal)
                onClicked: root.target.copy();
            }

            ToolButton {
                focusPolicy: Qt.NoFocus
                icon.name: "edit-paste"
                text: qsTr("Paste", "@action:inmenu Text editor action")
                visible: root.target && root.target.canPaste
                onClicked: root.target.paste();
            }
        }

        FontMetrics {
            id: fontMetrics
            font: root.target.font
        }
    }
}

