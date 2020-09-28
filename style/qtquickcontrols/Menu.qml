/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

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

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 0
    overlap: 1

    delegate: Controls.MenuItem {}

    contentItem: ListView {
        implicitHeight: contentHeight
        property bool hasCheckables: false
        property bool hasIcons: false
        model: control.contentModel
        highlightMoveDuration: -1
        highlightMoveVelocity: -1
        highlight: ListViewHighlight {}

        interactive: Window.window
                        ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height
                        : false
        clip: true
        currentIndex: control.currentIndex || 0
        keyNavigationEnabled: true
        keyNavigationWraps: true

        ScrollBar.vertical: Controls.ScrollBar {}
    }

    Connections {
        target: control.contentItem.contentItem

        function onChildrenChanged()
        {
            for (var i in control.contentItem.contentItem.children) {
                var child = control.contentItem.contentItem.children[i];
                if (child.checkable) {
                    control.contentItem.hasCheckables = true;
                }
                if (child.icon && child.icon.hasOwnProperty("name") && (child.icon.name.length > 0 || child.icon.source.length > 0)) {
                    control.contentItem.hasIcons = true;
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

    background: Kirigami.ShadowedRectangle {
        radius: 3
        implicitWidth: Kirigami.Units.gridUnit * 12
        color: Kirigami.Theme.backgroundColor

        border.color: Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.3);
        border.width: 1

        shadow.xOffset: 0
        shadow.yOffset: 2
        shadow.color: Qt.rgba(0, 0, 0, 0.3)
        shadow.size: 8
    }
}
