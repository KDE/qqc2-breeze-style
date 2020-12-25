/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

// TODO: I'm currently unsatisfied with the appearance of this
Loader {
    id: root
    property alias control: root.parent
    property bool isCurrentItem: isInListView && control.ListView.isCurrentItem
    property bool isInListView: control.ListView.view
    property bool listViewHasHighlight: isInListView && control.ListView.view.highlight
    property int currentIndex: isInListView ? control.ListView.view.currentIndex : 0
    property int count: isInListView ? control.ListView.view.count : 0

    // Rectangle compatibility properties. 3rd party devs might assume that these properties are available.
    property color color: {
        if (control.down      ) {
            return Kirigami.Theme.alternateBackgroundColor
        } else if (control.highlighted) {
            return Kirigami.Theme.highlightColor
        } else {
            return Qt.rgba(
                Kirigami.Theme.backgroundColor.r,
                Kirigami.Theme.backgroundColor.g,
                Kirigami.Theme.backgroundColor.b,
                0)
        }
    }
    property real radius: 0
    property QtObject border: QtObject {
        property real width: 0
        property color color: Kirigami.Theme.focusColor
    }

    visible: control.highlighted || control.down || control.hovered || control.visualFocus
    sourceComponent: visible ? backgroundComponent : null

    Component {
        id: backgroundComponent
        Kirigami.ShadowedRectangle {
            id: mainBackground
            implicitHeight: Kirigami.Units.mediumControlHeight
            anchors.fill: parent

            radius: root.radius
        //     readonly property real topRadius: root.isCurrentItem && root.currentIndex == 0 ? Kirigami.Units.smallRadius : 0
            //readonly property real bottomRadius: root.isCurrentItem && root.currentIndex == root.count-1 ? Kirigami.Units.smallRadius : 0

            //corners {
                //topLeftRadius: Kirigami.Units.smallRadius//root.topRadius
                //topRightRadius: Kirigami.Units.smallRadius//root.topRadius
                //bottomLeftRadius: Kirigami.Units.smallRadius//root.bottomRadius
                //bottomRightRadius: Kirigami.Units.smallRadius//root.bottomRadius
            //}

            color: root.color

            border {
                width: root.border.width
                color: root.border.color
            }

            Behavior on color {
                ColorAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                height: Kirigami.Units.smallBorder
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                color: mainBackground.border.color
            }
            Rectangle {
                height: Kirigami.Units.smallBorder
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                color: mainBackground.border.color
            }
        }
    }
}

