/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import org.kde.kirigami as Kirigami

import "." as Impl

Impl.StandardRectangle {
    id: root
    property int currentIndex: -1
    property int count: 0
    property bool alwaysCurveCorners: false
    readonly property real topRadius: (alwaysCurveCorners || root.currentIndex == 0) ? Impl.Units.smallRadius : 0
    readonly property real bottomRadius: (alwaysCurveCorners || root.currentIndex == Math.max(root.count-1, 0)) ? Impl.Units.smallRadius : 0

    Kirigami.Theme.colorSet: Kirigami.Theme.Selection
    Kirigami.Theme.inherit: false

    topLeftRadius: root.topRadius
    topRightRadius: root.topRadius
    bottomLeftRadius: root.bottomRadius
    bottomRightRadius: root.bottomRadius

    color: Kirigami.Theme.alternateBackgroundColor
    border {
        width: Impl.Units.smallBorder
        color: Kirigami.Theme.focusColor
    }
}
