// NOTE: check this
/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.Menu {
    id: control
    
    property bool __hasIndicators: false
    property bool __hasIcons: false
    property bool __hasArrows: false

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 0
    overlap: background.border.width

    delegate: Controls.MenuItem {
        __reserveSpaceForIndicator: control.__hasIndicators
        __reserveSpaceForIcon: control.__hasIcons
        __reserveSpaceForArrow: control.__hasArrows
    }

    contentItem: ListView {
        implicitHeight: contentHeight
        model: control.contentModel
        highlightMoveDuration: Kirigami.Units.shortDuration
//         highlightMoveVelocity: contentHeight
        highlight: ListViewHighlight {
            currentIndex: control.currentIndex
            count: control.count
        }
        // For some reason, `keyNavigationEnabled: true` isn't needed and
        // using it causes separators and disabled items to be highlighted
        keyNavigationWraps: true

        interactive: Window.window
                        ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height
                        : false
        clip: true
        currentIndex: control.currentIndex || 0

        ScrollBar.vertical: Controls.ScrollBar {}
    }

    //Connections {
        //target: control.contentItem.contentItem

        //function onChildrenChanged()
        //{
            //for (var i in control.contentItem.contentItem.children) {
                //var child = control.contentItem.contentItem.children[i];
                //if (child.indicator && child.indicator.visible) {
                    //control.__hasIndicators = true;
                //}
                //if (child.contentItem && child.contentItem.hasIcon) {
                    //control.__hasIcons = true;
                //}
                //if (child.arrow && child.arrow.visible) {
                    //control.__hasArrows = true
                //}
            //}
        //}
    //}

    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                easing.type: Easing.OutQuad
                duration: Kirigami.Units.shortDuration
            }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                easing.type: Easing.OutQuad
                duration: Kirigami.Units.shortDuration
            }
        }
    }

    background: Rectangle {
        radius: Kirigami.Units.smallRadius
        implicitHeight: Kirigami.Units.mediumControlHeight
        implicitWidth: Kirigami.Units.gridUnit * 15
        color: Kirigami.Theme.backgroundColor

        border {
            color: Kirigami.Theme.separatorColor
            width: Kirigami.Units.smallBorder
        }

        MediumShadow {
            radius: parent.radius
        }
    }
}
