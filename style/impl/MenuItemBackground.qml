/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import "." as Impl

Loader {
    id: root
    required property T.MenuItem control
    // God, this code is ugly. Somehow this works, but `control.ListView.view && control.ListView.view.highlight` doesn't.
    property bool isInListView: control.ListView.view ?? false
    property bool listViewHasHighlight: isInListView && (control.ListView.view.highlight ?? false)

    property color normalColor: control instanceof T.SwipeDelegate ? Kirigami.Theme.backgroundColor
        : Qt.rgba(
            Kirigami.Theme.backgroundColor.r,
            Kirigami.Theme.backgroundColor.g,
            Kirigami.Theme.backgroundColor.b,
            0
        )
    property bool highlightBackground: control.down || control.highlighted

    // Rectangle compatibility properties. 3rd party devs might assume that these properties are available.
    property color color: {
        if (highlightBackground) {
            return Kirigami.Theme.alternateBackgroundColor
        } else {
            return normalColor
        }
    }
    property real radius: Impl.Units.smallRadius
    property QtObject border: QtObject {
        property real width: root.highlightBackground ? Impl.Units.smallBorder : 0
        property color color: Kirigami.Theme.focusColor
    }

    property bool backgroundAnimationRunning: false
    property bool borderAnimationRunning: false

    visible: (highlightBackground || backgroundAnimationRunning || borderAnimationRunning) && !listViewHasHighlight
    active: visible
    sourceComponent: Component {
        Impl.StandardRectangle {
            id: mainBackground
            readonly property bool isCurrentItem: root.isInListView && control.ListView.isCurrentItem
            readonly property int currentIndex: root.isInListView ? control.ListView.view.currentIndex : 0
//             readonly property int count: root.isInListView ? control.ListView.view.count : 0
            readonly property bool horizontalListView: root.isInListView && control.ListView.view.orientation === ListView.Horizontal

            implicitHeight: Impl.Units.mediumControlHeight

            radius: root.radius
            readonly property real topRadius: !root.isInListView || (isCurrentItem && currentIndex == 0) ? radius : 0
            readonly property real bottomRadius: !root.isInListView || (isCurrentItem && currentIndex == control.ListView.view.count-1) ? radius : 0

            topLeftRadius: topRadius
            topRightRadius: topRadius
            bottomLeftRadius: bottomRadius
            bottomRightRadius: bottomRadius


            color: root.color

            border {
                width: root.border.width
                color: root.border.color
            }

            Behavior on color {
                enabled: root.highlightBackground
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                    onRunningChanged: root.backgroundAnimationRunning = running
                }
            }
            Behavior on border.color {
                enabled: root.highlightBackground
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                    onRunningChanged: root.borderAnimationRunning = running
                }
            }
        }
    }
}

