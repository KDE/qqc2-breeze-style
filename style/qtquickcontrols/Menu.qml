/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

T.Menu {
    id: control

    readonly property bool __hasIndicators: contentItem.contentItem.visibleChildren.some(menuItem => menuItem?.indicator?.visible ?? false)
    readonly property bool __hasIcons: contentItem.contentItem.visibleChildren.some(menuItem => __itemHasIcon(menuItem))
    readonly property bool __hasArrows: contentItem.contentItem.visibleChildren.some(menuItem => menuItem?.arrow?.visible ?? false)

    // palette: Kirigami.Theme.palette
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    padding: Kirigami.Units.smallSpacing
    margins: 0
    overlap: background && background.hasOwnProperty("border") ? background.border.width : 0
    z: Kirigami.OverlayZStacking.z

    function __itemHasIcon(item) {
        const hasName = (item?.icon?.name ?? "") !== ""
        const hasSource = (item?.icon?.source.toString() ?? "") !== ""
        return hasName || hasSource
    }

    // The default contentItem is a ListView, which has its own contentItem property,
    // so delegates will be created as children of control.contentItem.contentItem
    delegate: MenuItem {}

    contentItem: ListView {
        implicitHeight: contentHeight
        // Cannot use `contentWidth` as this only accounts for Actions, not MenuItems or MenuSeparators
        implicitWidth: contentItem.visibleChildren.reduce((maxWidth, child) => Math.max(maxWidth, child.implicitWidth), 0)
        model: control.contentModel
        highlightMoveDuration: 0
        highlight: Impl.ListViewHighlight {
            currentIndex: control.currentIndex
            count: control.count
            alwaysCurveCorners: true
        }
        // For some reason, `keyNavigationEnabled: true` isn't needed and
        // using it causes separators and disabled items to be highlighted
        keyNavigationWraps: true

        // Makes it so you can't drag/flick the list view around unless the menu is taller than the window
        interactive: Window.window ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height : false
        clip: interactive // Only needed when the ListView can be dragged/flicked
        currentIndex: control.currentIndex || 0

        ScrollBar.vertical: ScrollBar {}

        // Mimic qtwidgets behaviour regarding menu highlighting
        // Unselect item when unhover
        Connections {
            target: control.contentItem.currentItem

            function onHoveredChanged(): void {
                const item = control.contentItem.currentItem;
                if (item instanceof T.MenuItem && item.highlighted
                        && !item.subMenu && !item.hovered) {
                    control.currentIndex = -1
                }
            }
        }
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

    background: Impl.StandardRectangle {
        id: backgroundRect

        radius: Impl.Units.smallRadius
        implicitHeight: Impl.Units.mediumControlHeight
        implicitWidth: Kirigami.Units.gridUnit * 8
        color: Kirigami.Theme.backgroundColor

        border {
            color: Impl.Theme.separatorColor()
            width: Impl.Units.smallBorder
        }

        // Only load background shadow if menu is not a window, otherwise shadow gets cut off
        Impl.LargeShadow {
            visible: control.popupType === T.Popup.Item
            radius: backgroundRect.radius
        }
    }
}
