/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
Rectangle {
    id: raisedGradient
    anchors.fill: parent
    gradient: Gradient {
        GradientStop {
            position: 0
            color: Qt.rgba(1,1,1,0.03125)
        }
        GradientStop {
            position: 1
            color: Qt.rgba(0,0,0,0.0625)
        }
    }
    radius: Kirigami.Units.smallRadius
}
