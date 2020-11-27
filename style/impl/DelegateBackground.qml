/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

Kirigami.ShadowedRectangle {
    id: root

    property alias control: root.parent
    readonly property real topRadius: control.ListView.isCurrentItem &&
        control.ListView.view.currentIndex === 0 ?
        Kirigami.Units.smallRadius : 0
    readonly property real bottomRadius: control.ListView.isCurrentItem &&
        control.ListView.view.currentIndex === control.ListView.view.count-1 ?
        Kirigami.Units.smallRadius : 0

    visible: control.highlighted && !control.ListView.view.highlight

    Kirigami.Theme.colorSet: Kirigami.Theme.Selection
    Kirigami.Theme.inherit: false
    color: Kirigami.Theme.alternateBackgroundColor

    border {
        width: Kirigami.Units.smallBorder
        color: Kirigami.Theme.focusColor
    }

    corners {
        topLeftRadius: root.topRadius
        topRightRadius: root.topRadius
        bottomLeftRadius: root.bottomRadius
        bottomRightRadius: root.bottomRadius
    }
}
