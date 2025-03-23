/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T

IconLabelContent {
    id: root

    Loader {
        id: shortcutLabelLoader
        // rightPadding is actually left side padding when mirrored == true
        x: root.mirrored ? root.rightPadding : root.width - width - root.rightPadding
        y: root.labelRect.y
        width: Math.min(implicitWidth, Math.max(0, root.width - root.implicitWidth - root.spacing))
        active: Application.styleHints.showShortcutsInContextMenus
                && control.action
                && control.action.hasOwnProperty("shortcut")
                && control.action.shortcut !== undefined
                && !root.iconOnly
        sourceComponent: Component {
            T.Label {
                id: shortcutLabel
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }

                Shortcut {
                    id: itemShortcut
                    sequence: (shortcutLabel.visible && control.action !== null) ? control.action.shortcut : ""
                }

                text: itemShortcut.nativeText
                font: root.font
                color: root.color
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
