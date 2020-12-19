/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

// TODO: I'm currently unsatisfied with the appearance of this
Kirigami.ShadowedRectangle {
    id: root
    property alias control: root.parent
    property bool isCurrentItem: isInListView && control.ListView.isCurrentItem
    property bool isInListView: control.ListView.view
    property bool listViewHasHighlight: isInListView && control.ListView.view.highlight
    property int currentIndex: isInListView ? control.ListView.view.currentIndex : 0
    property int count: isInListView ? control.ListView.view.count : 0

    implicitHeight: Kirigami.Units.mediumControlHeight

//     radius: Kirigami.Units.smallRadius
//     readonly property real topRadius: root.isCurrentItem && root.currentIndex == 0 ? Kirigami.Units.smallRadius : 0
    //readonly property real bottomRadius: root.isCurrentItem && root.currentIndex == root.count-1 ? Kirigami.Units.smallRadius : 0

    visible: control.highlighted || control.down || control.hovered || control.visualFocus

    //corners {
        //topLeftRadius: Kirigami.Units.smallRadius//root.topRadius
        //topRightRadius: Kirigami.Units.smallRadius//root.topRadius
        //bottomLeftRadius: Kirigami.Units.smallRadius//root.bottomRadius
        //bottomRightRadius: Kirigami.Units.smallRadius//root.bottomRadius
    //}

    color: {
        if (control.down) {
            return Kirigami.Theme.alternateBackgroundColor
        } else if (control.highlighted) {
            return Kirigami.Theme.highlightColor
        } else {
            return "transparent"
        }
    }
//     border {
//         width: Kirigami.Units.smallBorder
//         color: Kirigami.Theme.focusColor
//     }
    Rectangle {
        height: Kirigami.Units.smallBorder
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        color: Kirigami.Theme.focusColor
    }
    Rectangle {
        height: Kirigami.Units.smallBorder
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: Kirigami.Theme.focusColor
    }
}
