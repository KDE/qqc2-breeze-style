/*
 *  SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami
import QtQuick.Controls 2.15 as Controls
import "../../templates" as T
import "../../private" as KP


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

    readonly property bool __isHeader: root.position == Controls.ToolBar.Header
    readonly property bool __isFooter: root.position == Controls.ToolBar.Footer

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Header

    topPadding: __isFooter ? 1 : 0 // Add space for the separator above the footer
    bottomPadding: __isHeader ? 1 : 0 // Add space for the separator below the header

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        Rectangle {
            id: shadow
            visible: root.separatorVisible && Kirigami.Settings.isMobile
            anchors {
                right: parent.right
                left: parent.left
                top: parent.bottom
            }
            height: Kirigami.Units.gridUnit
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(0, 0, 0, 0.25)
                }
                GradientStop {
                    position: 0.20
                    color: Qt.rgba(0, 0, 0, 0.1)
                }
                GradientStop {
                    position: 0.35
                    color: Qt.rgba(0, 0, 0, 0.02)
                }
                GradientStop {
                    position: 1.0
                    color:  "transparent"
                }
            }
            opacity: (!root.page.header || root.page.header.toString().indexOf("ToolBar") === -1)
            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Kirigami.Separator {
            id: separator
            visible: (root.__isHeader || root.__isFooter) && !Kirigami.Settings.isMobile
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: root.__isFooter ? parent.top : parent.bottom
                //verticalCenter: root.y <= 0 ? root.bottom : root.top
            }
        }
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}

