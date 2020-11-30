/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later OR LicenseRef-KDE-Accepted-LGPL OR LicenseRef-KFQF-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root

    property alias control: root.parent
    property real startPosition: control.first ? control.first.position : 0
    property real endPosition: control.second ? control.second.position : control.position
    property real endVisualPosition: control.second ? control.second.visualPosition : control.visualPosition

    implicitWidth: control.horizontal ? 200 : Kirigami.Units.grooveHeight
    implicitHeight: control.vertical ? 200 : Kirigami.Units.grooveHeight

    // RTL support
    scale: control.horizontal && control.mirrored ? -1 : 1

    radius: Math.min(width/2, height/2)
    color: Kirigami.Theme.backgroundColor
    border {
        width: Kirigami.Units.smallBorder
        color: Kirigami.Theme.separatorColor
    }

    Rectangle {
        id: fill
        x: root.control.horizontal ? root.startPosition * parent.width : 0
        y: root.control.vertical ? root.endVisualPosition * parent.height : 0
        width: root.control.horizontal ?
            root.endPosition * parent.width - root.startPosition * parent.width
            : Kirigami.Units.grooveHeight
        height: root.control.vertical ?
            root.endPosition * parent.height - root.startPosition * parent.height
            : Kirigami.Units.grooveHeight

        radius: parent.radius
        color: Kirigami.Theme.alternateBackgroundColor
        border {
            width: Kirigami.Units.smallBorder
            color: Kirigami.Theme.highlightColor
        }

        Behavior on x {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: root.implicitWidth*4
                //SmoothedAnimations have a hardcoded InOutQuad easing
            }
        }
        Behavior on y {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: root.implicitHeight*4
            }
        }
        Behavior on width {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: root.implicitWidth*4
            }
        }
        Behavior on height {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: root.implicitHeight*4
            }
        }

        // Prevents animations from running when loaded
        // HACK: for some reason, this won't work without a 1ms timer
        property bool loaded: false
        Timer {
            id: awfulHackTimer
            interval: 1
            onTriggered: fill.loaded = true
        }
        Component.onCompleted: {
            awfulHackTimer.start()
        }
    }
}
