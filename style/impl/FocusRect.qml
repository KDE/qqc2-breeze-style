/*
    SPDX-FileCopyrightText: 2018 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root
    property real baseRadius: 0
    anchors {
        fill: parent
        margins: -border.width
    }
    color: "transparent"
    radius: root.baseRadius > 0 ? root.baseRadius + border.width : 0
    border.color: Qt.rgba(Kirigami.Theme.highlightColor.r,
                            Kirigami.Theme.highlightColor.g,
                            Kirigami.Theme.highlightColor.b,
                            0.33)
    border.width: Kirigami.Units.mediumBorder
}
