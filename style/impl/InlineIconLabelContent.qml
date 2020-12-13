/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami


IconLabelContent {
    id: root
    Rectangle {
        z: -1
        x: root.labelRect.x
        y: root.labelRect.y + root.labelRect.height - height
        width: root.labelRect.width//root.hasIcon && root.hasLabel ? root.availableWidth - root.icon.width - root.spacing : root.availableWidth
        height: Kirigami.Units.focusUnderlineThickness
        visible: control.visualFocus
        color: Kirigami.Theme.focusColor
    }
}
