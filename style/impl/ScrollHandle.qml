/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

import "." as Impl

Rectangle {
    id: root
    property T.Control control: root.parent
    // ScrollIndicator does not have a policy property
    property int policy: T.ScrollBar.AsNeeded
    // ScrollIndicator does not have a pressed property
    property bool pressed: false

    visible: control.size < 1 && root.policy !== T.ScrollBar.AlwaysOff

    implicitWidth: Impl.Units.grooveHeight
    implicitHeight: implicitWidth

    radius: width / 2

    opacity: root.policy === T.ScrollBar.AsNeeded ? 0 : 1

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    color: root.pressed ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor

    Behavior on color {
        enabled: root.pressed
        ColorAnimation {
            duration: Impl.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    states: State {
        name: "active"
        when: root.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
        PropertyChanges {
            target: root
            opacity: root.policy === T.ScrollBar.AsNeeded ? 0.75 : 1
        }
    }

    transitions: Transition {
        from: "active"
        SequentialAnimation {
            PauseAnimation { duration: Impl.Units.veryLongDuration }
            OpacityAnimator {
                duration: Impl.Units.longDuration
                to: 0.0
            }
        }
    }
}
