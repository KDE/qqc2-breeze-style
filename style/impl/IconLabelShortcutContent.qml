/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

IconLabelContent {
    id: root
    Controls.Label {
        id: shortcutLabel
        x: root.width - shortcutLabel.width - (root.mirrored ? root.leftPadding : root.rightPadding)
        y: root.labelRect.y
        width: Math.min(shortcutLabel.contentWidth, Math.max(0, root.width - root.implicitWidth - root.spacing))
        visible: Qt.styleHints.showShortcutsInContextMenus && control.action && control.action.hasOwnProperty("shortcut") && control.action.shortcut !== undefined && !root.iconOnly

        Shortcut {
            id: itemShortcut
            sequence: (shortcutLabel.visible && control.action !== null) ? control.action.shortcut : ""
        }

        text: itemShortcut.nativeText
        font: root.font
        color: root.color
        horizontalAlignment: root.textUnderIcon ? Text.AlignHCenter : Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }
}
