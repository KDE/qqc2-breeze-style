/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

// TODO: I'm currently unsatisfied with the appearance of this
Loader {
    id: root
    property T.ItemDelegate control: root.parent

    property color normalColor: control instanceof T.SwipeDelegate ? Kirigami.Theme.backgroundColor
        : Qt.rgba(
            Kirigami.Theme.backgroundColor.r,
            Kirigami.Theme.backgroundColor.g,
            Kirigami.Theme.backgroundColor.b,
            0
        )
    property bool highlightBorder: control.hovered || control.visualFocus || control.down || control.highlighted

    // Rectangle compatibility properties. 3rd party devs might assume that these properties are available.
    property color color: {
        if (control.down || control.highlighted) {
            return Kirigami.Theme.alternateBackgroundColor
        } else {
            return normalColor
        }
    }
    property real radius: Kirigami.Units.smallRadius
    property QtObject border: QtObject {
        property real width: highlightBorder ? Kirigami.Units.smallBorder : 0
        property color color: Kirigami.Theme.focusColor
    }

    property bool backgroundAnimationRunning: false
    property bool borderAnimationRunning: false

    visible: (highlightBorder || backgroundAnimationRunning || borderAnimationRunning || control instanceof T.SwipeDelegate)
    active: visible
    sourceComponent: Component {
        Kirigami.ShadowedRectangle {
            id: mainBackground

            implicitHeight: Kirigami.Units.mediumControlHeight

            radius: root.radius

            color: root.color

            border {
                width: root.border.width
                color: root.border.color
            }

            Behavior on color {
                enabled: control.down
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                    onRunningChanged: root.backgroundAnimationRunning = running
                }
            }
            Behavior on border.color {
                enabled: highlightBorder
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                    onRunningChanged: root.borderAnimationRunning = running
                }
            }
        }
    }
}

