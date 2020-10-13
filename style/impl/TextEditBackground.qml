/*
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: mainBackground

    property alias control: mainBackground.parent

    implicitWidth: Kirigami.Units.mediumControlHeight
    implicitHeight: Kirigami.Units.mediumControlHeight

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false
    color: Kirigami.Theme.backgroundColor
    radius: Kirigami.Units.smallRadius
    border {
        color: control.activeFocus || control.hovered ?
                Kirigami.Theme.focusColor :
                Kirigami.ColorUtils.tintWithAlpha(mainBackground.color, Kirigami.Theme.textColor, 0.3)
        width: Kirigami.Units.smallBorder
    }
}
