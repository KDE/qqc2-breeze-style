/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.1
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root
    property bool useRoundTop: true
    property bool useRoundBottom: true
    readonly property real topRadius: useRoundTop ? Kirigami.Units.smallRadius : 0
    readonly property real bottomRadius: useRoundBottom ? Kirigami.Units.smallRadius : 0

    Kirigami.Theme.colorSet: Kirigami.Theme.Selection
    Kirigami.Theme.inherit: false
    radius: Kirigami.Units.smallRadius

//     corners {
//         topLeftRadius: root.topRadius
//         topRightRadius: root.topRadius
//         bottomLeftRadius: root.bottomRadius
//         bottomRightRadius: root.bottomRadius
//     }

    color: Kirigami.Theme.alternateBackgroundColor
    border {
        width: Kirigami.Units.smallBorder
        color: Kirigami.Theme.focusColor
    }
}
