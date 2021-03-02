/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

Kirigami.ShadowedRectangle {
    id: root
    property int currentIndex: -1
    property int count: 0
    readonly property real topRadius: root.currentIndex == 0 ? Kirigami.Units.smallRadius : 0
    readonly property real bottomRadius: root.currentIndex == Math.max(root.count-1, 0) ? Kirigami.Units.smallRadius : 0

    Kirigami.Theme.colorSet: Kirigami.Theme.Selection
    Kirigami.Theme.inherit: false

    corners {
        topLeftRadius: root.topRadius
        topRightRadius: root.topRadius
        bottomLeftRadius: root.bottomRadius
        bottomRightRadius: root.bottomRadius
    }

    color: Kirigami.Theme.alternateBackgroundColor
    border {
        width: Kirigami.Units.smallBorder
        color: Kirigami.Theme.focusColor
    }
}
