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
    overlap: background && background.hasOwnProperty("border") ? background.border.width : 0

    // The default contentItem is a ListView, which has its own contentItem property,
    // so delegates will be created as children of control.contentItem.contentItem
    delegate: Controls.MenuItem {}

    contentItem: ListView {
        implicitHeight: contentHeight
        implicitWidth: contentWidth
        model: control.contentModel
        highlightMoveDuration: Kirigami.Units.shortDuration
        highlightMoveVelocity: Kirigami.Units.gridUnit * 20
        highlight: ListViewHighlight {
            currentIndex: control.currentIndex
            count: control.count
        }
        // For some reason, `keyNavigationEnabled: true` isn't needed and
        // using it causes separators and disabled items to be highlighted
        keyNavigationWraps: true

        // Makes it so you can't drag/flick the list view around unless the menu is taller than the window
        interactive: Window.window ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height : false
        clip: interactive // Only needed when the ListView can be dragged/flicked
        currentIndex: control.currentIndex || 0

        ScrollBar.vertical: Controls.ScrollBar {}
    }

    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                easing.type: Easing.OutCubic
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
                easing.type: Easing.InCubic
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

        LargeShadow {
            radius: parent.radius
        }
    }
}
