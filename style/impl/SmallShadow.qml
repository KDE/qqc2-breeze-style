/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.19 as Kirigami

import "." as Impl

Loader {
    id: root
    property real radius: Impl.Units.smallRadius
    anchors.fill: parent
    z: -1
    active: visible && !Kirigami.Theme.lowPowerHardware
    sourceComponent: Component {
        Kirigami.ShadowedRectangle {
            anchors.fill: parent
            radius: root.radius
            color: "transparent"
            shadow {
                color: Qt.rgba(0,0,0,0.2)
                size: 2
                yOffset: 1
            }
            opacity: parent.opacity
            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
