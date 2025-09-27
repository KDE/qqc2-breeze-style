/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import "." as Impl

Impl.StandardRectangle {
    id: root
    required property T.Control control
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
    color: root.pressed ? Kirigami.Theme.focusColor : Impl.Theme.separatorColor()

    Behavior on color {
        enabled: root.pressed
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
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
            PauseAnimation { duration: Kirigami.Units.veryLongDuration }
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                to: 0.0
            }
        }
    }
}
