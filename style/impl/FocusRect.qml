/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami

import "." as Impl

Loader {
    id: root
    property real baseRadius: 0
    active: visible
    anchors.fill: parent
    sourceComponent: Component {
        Impl.StandardRectangle {
            id: innerRing
            anchors {
                fill: parent
                margins: -border.width
            }
            color: "transparent"
            radius: root.baseRadius > 0 ? root.baseRadius + border.width : 0
            border.color: Qt.rgba(
                Kirigami.Theme.focusColor.r,
                Kirigami.Theme.focusColor.g,
                Kirigami.Theme.focusColor.b,
                0.42
            )
            border.width: Impl.Units.mediumBorder/2

            Impl.StandardRectangle {
                id: outerRing
                anchors {
                    fill: parent
                    margins: -border.width
                }
                color: "transparent"
                radius: parent.radius > 0 ? parent.radius + border.width : 0
                border.color: Qt.rgba(
                    Kirigami.Theme.focusColor.r,
                    Kirigami.Theme.focusColor.g,
                    Kirigami.Theme.focusColor.b,
                    0.28
                )
                border.width: parent.border.width
            }
        }
    }
}
