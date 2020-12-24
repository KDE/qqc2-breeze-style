/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

Loader {
    id: root
    anchors.fill: parent
    z: -1
    property real radius: Kirigami.Units.smallRadius
    sourceComponent: visible && !Kirigami.Theme.lowPowerHardware ? shadowComponent : null
    Component {
        id: shadowComponent
        Kirigami.ShadowedRectangle {
            anchors.fill: parent
            radius: root.radius
            color: "transparent"
            shadow {
                color: Qt.rgba(0,0,0,0.2)
                size: 16
                yOffset: 4
            }
        }
    }
}
