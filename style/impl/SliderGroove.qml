/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later OR LicenseRef-KDE-Accepted-LGPL OR LicenseRef-KFQF-Accepted-GPL
*/

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: groove

    property alias control: groove.parent
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
        x: groove.control.horizontal ? groove.startPosition * parent.width : 0
        y: groove.control.vertical ? groove.endVisualPosition * parent.height : 0
        width: groove.control.horizontal ?
            groove.endPosition * parent.width - groove.startPosition * parent.width
            : Kirigami.Units.grooveHeight
        height: groove.control.vertical ?
            groove.endPosition * parent.height - groove.startPosition * parent.height
            : Kirigami.Units.grooveHeight

        radius: parent.radius
        color: Kirigami.Theme.alternateBackgroundColor
        border {
            width: Kirigami.Units.smallBorder
            color: Kirigami.Theme.highlightColor
        }

        /* TODO: These animations run sometimes when a page with Sliders is loaded.
         * I should find a way to prevent that from happening.
         */
        Behavior on x {
            enabled: !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: groove.implicitWidth*4
                //SmoothedAnimations have a hardcoded InOutQuad easing
            }
        }
        Behavior on y {
            enabled: !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: groove.implicitHeight*4
            }
        }
        Behavior on width {
            enabled: !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: groove.implicitWidth*4
            }
        }
        Behavior on height {
            enabled: !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: groove.implicitHeight*4
            }
        }
    }
}
