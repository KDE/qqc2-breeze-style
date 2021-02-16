/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root
    property alias control: root.parent
    // ScrollIndicator does not have a policy property
    property int policy: Controls.ScrollBar.AsNeeded
    // ScrollIndicator does not have a pressed property
    property bool pressed: false

    visible: control.size < 1 && root.policy !== Controls.ScrollBar.AlwaysOff

    implicitWidth: Kirigami.Units.grooveHeight
    implicitHeight: implicitWidth

    radius: width / 2

    opacity: root.policy === Controls.ScrollBar.AsNeeded ? 0 : 1

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    color: root.pressed ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor

    Behavior on color {
        enabled: root.pressed
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    states: State {
        name: "active"
        when: root.policy === Controls.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
        PropertyChanges {
            target: root
            opacity: root.policy === Controls.ScrollBar.AsNeeded ? 0.75 : 1
        }
    }

    transitions: Transition {
        from: "active"
        SequentialAnimation {
            PauseAnimation { duration: 450 }
            OpacityAnimator {
                //target: control.contentItem
                duration: Kirigami.Units.longDuration
                //property: "opacity"
                to: 0.0
            }
        }
    }
}
