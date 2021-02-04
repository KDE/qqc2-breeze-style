/* SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.14 as Kirigami

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
        margins: Kirigami.Units.verySmallSpacing

        x: xAlignHCenter
        y: yAlignOver

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

