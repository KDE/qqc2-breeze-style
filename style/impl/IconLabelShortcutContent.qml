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
        Layout.alignment: {
            let halignment = root.alignment & Qt.AlignHorizontal_Mask
            let valignment = root.alignment & Qt.AlignVertical_Mask
            if (halignment & Qt.AlignLeft) {
                halignment = Qt.AlignRight
            }
            if (valignment & Qt.AlignTop) {
                valignment = Qt.AlignBottom
            }
            return halignment | valignment
        }
        Layout.leftMargin: label.visible && root.horizontal ? 0 : root.leftPadding
        Layout.rightMargin: root.rightPadding
        Layout.topMargin: label.visible && root.vertical ? 0 : root.topPadding
        Layout.bottomMargin: root.bottomPadding
        visible: Qt.styleHints.showShortcutsInContextMenus && control.action && control.action.hasOwnProperty("shortcut") && control.action.shortcut !== undefined && root.display !== Controls.AbstractButton.IconOnly

        Shortcut {
            id: itemShortcut
            sequence: (shortcutLabel.visible && control.action !== null) ? control.action.shortcut : ""
        }

        text: itemShortcut.nativeText
        font: control.font
        color: label.color
        horizontalAlignment: label.horizontalAlignment === Text.AlignLeft ? Text.AlignRight : label.horizontalAlignment
        verticalAlignment: label.verticalAlignment === Text.AlignTop ? Text.AlignBottom : label.verticalAlignment
    }
}
