/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: root

    property alias control: root.parent
    property bool mirrored: control.mirrored
    readonly property bool controlHasContent: control.contentItem && control.contentItem.width > 0

    implicitWidth: implicitHeight
    implicitHeight: Kirigami.Units.inlineControlHeight

    x: controlHasContent ? (root.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
    y: control.topPadding + (control.availableHeight - height) / 2

    radius: width / 2

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false
    color: control.down || control.checked ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor

    border {
        width: Kirigami.Units.smallBorder
        color: control.down || control.checked || control.visualFocus || control.hovered ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
    }

    Behavior on color {
        enabled: control.down || control.checked
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    Behavior on border.color {
        enabled: control.down || control.checked || control.visualFocus || control.hovered
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    SmallShadow {
        id: shadow
        opacity: control.down ? 0 : 1
        visible: control.enabled
        z: -1
        radius: parent.radius
    }

    // Using Kirigami.ShadowedRectangle because Rectangle looks a bit jagged at 2x scaling even with antialiasing
    Kirigami.ShadowedRectangle {
        id: mark
        anchors.centerIn: parent
        implicitHeight: {
            let h = root.height/2
            h -= h % 2
            return h
        }
        implicitWidth: implicitHeight
        radius: height / 2
        color: Kirigami.Theme.textColor
        // slight glow gives subtle depth
        shadow {
            size: 2
            color: mark.color
        }
        visible: control.checked
        scale: 0.8
    }

    FocusRect {
        baseRadius: root.radius
        visible: control.visualFocus
    }

    states: [
        State {
            when: !control.checked
            name: "unchecked"
            PropertyChanges {
                target: mark
                scale: 0.8
            }
        },
        State {
            when: control.checked
            name: "checked"
            PropertyChanges {
                target: mark
                scale: 1
            }
        }
    ]

    transitions: [
        /* Using `from: "unchecked"` instead of `from: "*"` prevents the transition
         * from running when the parent control is created.
         * This can reduce resource usage spikes on pages that have way too many
         * controls with indicators.
         */
        Transition {
            from: "unchecked"
            to: "checked"
            ScaleAnimator {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutQuad
            }
        }
    ]
}
