/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later OR LicenseRef-KDE-Accepted-LGPL OR LicenseRef-KFQF-Accepted-GPL
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as Templates
import org.kde.kirigami as Kirigami

import "." as Impl

Impl.StandardRectangle {
    id: root

    required property Templates.Control control
    property real startPosition: isRangeSlider ? control.first.position : 0
    property real endPosition: isRangeSlider ? control.second.position : control.position

    readonly property bool isRangeSlider: control instanceof Templates.RangeSlider

    readonly property real handleWidth: isRangeSlider ? control.first.handle.width ?? 0 : control.handle.width ?? 0
    readonly property real handleHeight: isRangeSlider ? control.first.handle.height ?? 0 : control.handle.height ?? 0
    readonly property real secondHandleWidth: isRangeSlider ? control.second.handle.width ?? 0 : handleWidth
    readonly property real secondHandleHeight: isRangeSlider ? control.second.handle.height ?? 0 : handleHeight

    readonly property bool horizontal: root.control.horizontal
    readonly property bool vertical: root.control.vertical


    //NOTE: Manually setting x,y,width,height because that's what the Basic, Fusion and Material QQC2 styles do.
    // Inset would be more idiomatic for QQC2, but this is easier to deal with for now since the behavior is expected by app devs.

    x: control.leftPadding + (root.horizontal ?
        (control.mirrored ? root.secondHandleWidth/2 : root.handleWidth/2) - radius
        : (control.availableWidth - width) / 2)
    y: control.topPadding + (root.vertical ? root.secondHandleHeight/2 - radius : (control.availableHeight - height) / 2)

    implicitWidth: root.horizontal ? 200 : Impl.Units.grooveHeight
    implicitHeight: root.vertical ? 200 : Impl.Units.grooveHeight

    width: root.horizontal ? control.availableWidth - root.handleWidth/2 - secondHandleWidth/2 + Impl.Units.grooveHeight : implicitWidth
    height: root.vertical ? control.availableHeight - root.handleHeight/2 - secondHandleHeight/2 + Impl.Units.grooveHeight : implicitHeight

    radius: Impl.Units.grooveHeight/2
    color: Kirigami.Theme.backgroundColor
    border {
        width: Impl.Units.smallBorder
        color: Impl.Theme.separatorColor()
    }

    Impl.StandardRectangle {
        id: fill
        anchors {
            fill: parent
            leftMargin: root.horizontal ? root.startPosition * parent.width - (root.startPosition * Impl.Units.grooveHeight) : 0
            rightMargin: root.horizontal ? (1-root.endPosition) * parent.width - ((1-root.endPosition) * Impl.Units.grooveHeight) : 0
            topMargin: root.vertical ? (1-root.endPosition) * parent.height - ((1-root.endPosition) * Impl.Units.grooveHeight) : 0
            bottomMargin: root.vertical ? root.startPosition * parent.height - (root.startPosition * Impl.Units.grooveHeight) : 0
        }

        radius: parent.radius
        color: Kirigami.Theme.alternateBackgroundColor
        border {
            width: Impl.Units.smallBorder
            color: Kirigami.Theme.focusColor
        }

        Behavior on anchors.leftMargin {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: 800
                //SmoothedAnimations have a hardcoded InOutQuad easing
            }
        }
        Behavior on anchors.rightMargin {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: 800
            }
        }
        Behavior on anchors.topMargin {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: 800
            }
        }
        Behavior on anchors.bottomMargin {
            enabled: fill.loaded && !Kirigami.Settings.hasTransientTouchInput
            SmoothedAnimation {
                duration: Kirigami.Units.longDuration
                velocity: 800
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

    // Limit tick density while retaining multiples of the requested step size.
    readonly property real tickRange: Math.abs(control.to - control.from)
    readonly property real tickLength: Math.max(0, (horizontal ? width : height) - 2 * radius)
    readonly property real tickStep: {
        const hint = control.Kirigami.StyleHints.tickMarkStepSize;
        const step = hint === 0 ? control.stepSize : hint;
        if (step <= 0 || tickRange <= 0 || tickLength <= 0) {
            return 0;
        }
        return step * Math.max(1, Math.ceil((tickRange / step) / Math.max(1, Math.floor(tickLength / 5))));
    }

    Repeater {
        model: root.tickStep > 0 ? Math.floor(root.tickRange / root.tickStep) + 1 : 0
        delegate: Item {
            id: tick
            required property int index
            readonly property real position: index * root.tickStep / root.tickRange
            readonly property real visualPosition: root.vertical || root.control.mirrored ? 1 - position : position
            x: root.horizontal ? Math.round(root.radius + visualPosition * root.tickLength - width / 2) : 0
            y: root.vertical ? Math.round(root.radius + visualPosition * root.tickLength - height / 2) : 0
            width: root.horizontal ? Impl.Units.mediumBorder : root.width
            height: root.vertical ? Impl.Units.mediumBorder : root.height

            Rectangle {
                x: root.horizontal ? 0 : -Kirigami.Units.mediumSpacing
                y: root.vertical ? 0 : -Kirigami.Units.mediumSpacing
                width: root.horizontal ? tick.width : Kirigami.Units.smallSpacing
                height: root.vertical ? tick.height : Kirigami.Units.smallSpacing
                color: Impl.Theme.separatorColor()
            }
            Rectangle {
                x: root.horizontal ? 0 : tick.width + Kirigami.Units.smallSpacing / 2
                y: root.vertical ? 0 : tick.height + Kirigami.Units.smallSpacing / 2
                width: root.horizontal ? tick.width : Kirigami.Units.smallSpacing
                height: root.vertical ? tick.height : Kirigami.Units.smallSpacing
                color: Impl.Theme.separatorColor()
            }
        }
    }
}
