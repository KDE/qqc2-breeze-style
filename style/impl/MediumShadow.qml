/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami

import "." as Impl

Loader {
    id: root
    property real radius: Impl.Units.smallRadius
    anchors.fill: parent
    z: -1
    active: visible
    sourceComponent: Component {
        Kirigami.ShadowedRectangle {
            anchors.fill: parent
            radius: root.radius
            color: "transparent"
            shadow {
                color: Qt.rgba(0,0,0,0.2)
                size: 9
                yOffset: 2
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
