/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

T.ScrollView {
    id: controlRoot

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: !background || !background.visible

    // size in pixel to accommodate the border drawn by qstyle
    topPadding: controlRoot.background?.visible ? (background.topPadding ?? 0) : 0
    leftPadding: (controlRoot.background?.visible ? (background.leftPadding ?? 0) : 0)
                    + (mirrored ? internal.verticalScrollBarWidth : 0)
    rightPadding: (controlRoot.background?.visible ? (background.rightPadding ?? 0) : 0)
                    + (!mirrored ? internal.verticalScrollBarWidth : 0)
    bottomPadding: (controlRoot.background?.visible ? (background.bottomPadding ?? 0) : 0)
                    + internal.horizontalScrollBarHeight

    data: [
        Kirigami.WheelHandler {
            target: controlRoot.contentItem
        },
        QtObject {
            id: internal

            readonly property real verticalScrollBarWidth: controlRoot.ScrollBar.vertical.visible && controlRoot.ScrollBar.vertical.interactive ? controlRoot.ScrollBar.vertical.width : 0
            readonly property real horizontalScrollBarHeight: controlRoot.ScrollBar.horizontal.visible && controlRoot.ScrollBar.vertical.interactive ? controlRoot.ScrollBar.horizontal.height : 0
        }
    ]

    ScrollBar.vertical: ScrollBar {
        parent: controlRoot
        z: 1
        x: controlRoot.mirrored
            ? (controlRoot.background?.visible ? (controlRoot.background.leftPadding ?? 0) : 0)
            : controlRoot.width - width - (controlRoot.background?.visible ? (controlRoot.background.rightPadding ?? 0) : 0)
        y: controlRoot.topPadding
        height: controlRoot.availableHeight
        active: controlRoot.ScrollBar.horizontal.active
    }

    ScrollBar.horizontal: ScrollBar {
        parent: controlRoot
        z: 1
        x: controlRoot.leftPadding
        y: controlRoot.height - height - (controlRoot.background?.visible ? (controlRoot.background.bottomPadding ?? 0) : 0)
        width: controlRoot.availableWidth
        active: controlRoot.ScrollBar.vertical.active
    }
}
