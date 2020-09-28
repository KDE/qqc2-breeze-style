/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.1
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

    Kirigami.Theme.colorSet: Kirigami.Theme.Selection
    Kirigami.Theme.inherit: false

    corners {
        topLeftRadius: root.topRadius
        topRightRadius: root.topRadius
        bottomLeftRadius: root.bottomRadius
        bottomRightRadius: root.bottomRadius
    }

    visible: control.highlighted && !control.ListView.view.highlight
    color: Kirigami.Theme.alternateBackgroundColor
    border {
        width: Kirigami.Units.smallBorder
        color: Kirigami.Theme.focusColor
    }
}
