/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root

    property alias control: root.parent
    property bool usePreciseHandle: false

    implicitHeight: Kirigami.Units.gridUnit
    implicitWidth: implicitHeight
    width: height
    radius: height / 2
    color: Kirigami.Theme.backgroundColor
    border {
        width: Kirigami.Units.smallBorder
        color: control.pressed || control.visualFocus || control.hovered ?
            Kirigami.Theme.highlightColor : Kirigami.Theme.separatorColor
            //Kirigami.ColorUtils.tintWithAlpha(root.color, Kirigami.Theme.textColor, 0.3)
    }

    SmallShadow {
        id: shadow
        radius: parent.radius
    }

    Rectangle {
        id: pointyBit

        visible: usePreciseHandle
        x: (parent.width - width)/2
        // HACK ?: this happens to have a value that works good enough when parent.height == 18
        y: (parent.height - height)/2 + parent.height/3

        // HACK ?: this happens to have a value that works good enough when parent.height == 18
        height: (parent.height + root.border.width) / 2

        width: height
        antialiasing: true
        rotation: 45
        color: root.color

        Rectangle {
            id: rightLine
            antialiasing: true
            color: root.border.color
            anchors {
                right: parent.right
                top: parent.top
//                 topMargin: width/2
                bottom: parent.bottom
            }
            width: root.border.width
        }
        Rectangle {
            id: leftLine
            antialiasing: true
            color: root.border.color
            anchors {
                left: parent.left
//                 leftMargin: height/2
                right: parent.right
                bottom: parent.bottom
            }
            height: root.border.width
        }
    }

    FocusRect {
        baseRadius: root.radius
        visible: control.visualFocus
    }
}
