/*
 *  SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import org.kde.kirigami 2.14
import QtQuick.Controls 2.15 as Controls
import "../../templates" as T


/**
 * An item that can be used as a title for the application.
 * Scrolling the main page will make it taller or shorter (trough the point of going away)
 * It's a behavior similar to the typical mobile web browser addressbar
 * the minimum, preferred and maximum heights of the item can be controlled with
 * * minimumHeight: default is 0, i.e. hidden
 * * preferredHeight: default is Units.gridUnit * 1.6
 * * maximumHeight: default is Units.gridUnit * 3
 *
 * To achieve a titlebar that stays completely fixed just set the 3 sizes as the same
 */
T.AbstractApplicationHeader {
    id: root

    readonly property bool isHeader: root.position == Controls.ToolBar.Header
    readonly property bool isFooter: root.position == Controls.ToolBar.Footer

    Theme.inherit: false
    Theme.colorSet: Theme.Header

    topPadding: isFooter ? 1 : 0 // Add space for the separator above the footer
    bottomPadding: isHeader ? 1 : 0 // Add space for the separator below the header

    background: Rectangle {
        color: Theme.backgroundColor
        Separator {
            id: separator
            visible: root.isHeader || root.isFooter
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: root.isFooter ? parent.top : parent.bottom
                //verticalCenter: root.y <= 0 ? root.bottom : root.top
            }
        }
    }
}

