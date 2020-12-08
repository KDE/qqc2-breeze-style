/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

Kirigami.ShadowedRectangle {
    id: root
    anchors.fill: parent
    z: -1
    radius: Kirigami.Units.smallRadius
    color: "transparent"//shadow.color
    shadow {
        color: Qt.rgba(0,0,0,0.2)
        size: 3
        yOffset: 1
    }
    Component.onCompleted: {
        if (Kirigami.Theme.lowPowerHardware) {
            root.visible = false
        }
    }
}
