/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root
    property alias control: root.parent
    // Makes this work for ScrollBar and ScrollIndicator
    property int policy: Controls.ScrollBar.AsNeeded

    visible: control.size < 1 && root.policy !== Controls.ScrollBar.AlwaysOff

    implicitWidth: Kirigami.Units.grooveHeight
    implicitHeight: implicitWidth

    radius: width / 2
    color: control.pressed ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
    opacity: root.policy === Controls.ScrollBar.AsNeeded ? 0 : 1

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
