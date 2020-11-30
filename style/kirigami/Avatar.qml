/*
 *  SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.13
import "../../" as Base
import QtQuick.Controls 2.13 as QQC2
import QtQuick.Templates 2.13 as T
import org.kde.kirigami.private 2.13
import "../../templates/private" as P

import "impl"

Base.Avatar {
    id: root

    border.width: 0

    SmallShadow {
        id: shadow
        parent: background
        anchors.fill: background
//         visible: !control.flat && !control.down && control.enabled
        z: -1
        radius: parent.radius
    }
}
