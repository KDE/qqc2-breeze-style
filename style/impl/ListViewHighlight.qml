/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick

import "." as Impl

Impl.StandardRectangle {
    id: root
    property int currentIndex: -1
    property int count: 0
    property bool alwaysCurveCorners: false
    readonly property real topRadius: (alwaysCurveCorners || root.currentIndex == 0) ? Impl.Units.smallRadius : 0
    readonly property real bottomRadius: (alwaysCurveCorners || root.currentIndex == Math.max(root.count-1, 0)) ? Impl.Units.smallRadius : 0

    topLeftRadius: root.topRadius
    topRightRadius: root.topRadius
    bottomLeftRadius: root.bottomRadius
    bottomRightRadius: root.bottomRadius

    color: palette.highlight
    border {
        width: Impl.Units.smallBorder
        color: palette.highlight
    }
}
