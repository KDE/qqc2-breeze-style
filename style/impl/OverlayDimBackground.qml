/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

import "." as Impl

Rectangle {
    color: Qt.rgba(0,0,0,0.2)
    Behavior on opacity {
        OpacityAnimator {
            duration: Impl.Units.longDuration
        }
    }
}
