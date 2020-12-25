/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.6
import org.kde.kirigami 2.14 as Kirigami

Loader {
    id: root
    property real baseRadius: 0
    property bool unloaded: !visible
    anchors.fill: parent
    sourceComponent: unloaded ? null : focusRectComponent
    Component {
        id: focusRectComponent
        Rectangle {
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
            border.width: Kirigami.Units.mediumBorder/2

            Rectangle {
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
            opacity: 0
            OpacityAnimator on opacity {
                id: opacityAnimator
                running: true
                from: 0
                to: 1
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InCubic
            }
        }
    }
}
