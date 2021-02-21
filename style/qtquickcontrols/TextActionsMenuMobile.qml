/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

Controls.Menu {
    id: root

    delegate: Controls.ToolButton {
        display: Controls.AbstractButton.IconOnly
    }

    contentItem: Loader {
        property alias control: root
        sourceComponent: Kirigami.Settings.isMobile ? mobileContentItemComponent : desktopContentItemComponent
    }

    Component {
        id: desktopContentItemComponent
        ListView {
            id: listView
            implicitHeight: contentHeight
            model: control.contentModel
            // For some reason, `keyNavigationEnabled: true` isn't needed and
            // using it causes separators and disabled items to be highlighted
            keyNavigationWraps: true

    //         interactive: Window.window ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height : false
    //         clip: true
            currentIndex: control.currentIndex || 0

            highlightMoveDuration: Kirigami.Units.shortDuration
            highlightMoveVelocity: Kirigami.Units.gridUnit * 20
            highlight: ListViewHighlight {
                currentIndex: control.currentIndex
                count: control.count
            }

            ScrollBar.vertical: Controls.ScrollBar {}
        }
    }
    Component {
        id: mobileContentItemComponent
        Kirigami.ToolBarLayout {
            id: toolBarLayout
            heightMode: Kirigami.ToolBarLayout.AlwaysCenter
            alignment: Qt.AlignLeft | Qt.AlignVCenter
            spacing: Kirigami.Units.smallSpacing
            fullDelegate: Controls.ToolButton {
                action: Kirigami.ToolBarLayout.action
            }
            iconDelegate: Controls.ToolButton {
                display: Controls.AbstractButton.IconOnly
                action: Kirigami.ToolBarLayout.action
            }
            moreButton: Controls.ToolButton {
                icon.name: "overflow-menu"
                display: Controls.AbstractButton.IconOnly
                action: Kirigami.ToolBarLayout.action
            }
        }
    }

    Kirigami.Action {
        text: qsTr("Cut")
        displayHint: Kirigami.Settings.isMobile ? Kirigami.DisplayHint.IconOnly : Kirigami.DisplayHint.NoPreference
    }
    Kirigami.Action {
        text: qsTr("Copy")
        displayHint: Kirigami.Settings.isMobile ? Kirigami.DisplayHint.IconOnly : Kirigami.DisplayHint.NoPreference
    }
    Kirigami.Action {
        text: qsTr("Paste")
        displayHint: Kirigami.Settings.isMobile ? Kirigami.DisplayHint.IconOnly : Kirigami.DisplayHint.NoPreference
    }
    Kirigami.Action {
        text: qsTr("Select All")
        displayHint: Kirigami.Settings.isMobile ? Kirigami.DisplayHint.AlwaysHide : Kirigami.DisplayHint.NoPreference
    }
    Kirigami.Action {
        text: qsTr("Share")
        displayHint: Kirigami.Settings.isMobile ? Kirigami.DisplayHint.AlwaysHide : Kirigami.DisplayHint.NoPreference
    }
}
