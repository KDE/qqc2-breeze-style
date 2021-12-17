/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

import "impl" as Impl

T.ToolBar {
    id: control

    readonly property bool __isHeader: control.position === T.ToolBar.Header
    readonly property bool __isFooter: control.position === T.ToolBar.Footer

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: Impl.Units.smallSpacing

    padding: Impl.Units.smallSpacing

    // Add space for the separator above the footer
    topPadding: __isFooter && background && background.hasOwnProperty("separator") ?
        background.separator.height + verticalPadding : verticalPadding
    // Add space for the separator below the header
    bottomPadding: __isHeader && background && background.hasOwnProperty("separator") ?
        background.separator.height + verticalPadding : verticalPadding

    Kirigami.Theme.inherit: !__isHeader
    Kirigami.Theme.colorSet: Kirigami.Theme.Header

    background: Rectangle {
        // Enough height for Buttons/ComboBoxes/TextFields with smallSpacing padding on top and bottom
        implicitHeight: Impl.Units.mediumControlHeight + (Impl.Units.smallSpacing * 2) + (separator.visible ? separator.height : 0)
        color: Kirigami.Theme.backgroundColor
        property Item separator: Kirigami.Separator {
            parent: background
            visible: control.__isHeader || control.__isFooter
            width: parent.width
            y: control.__isFooter ? 0 : parent.height - height
        }
    }
}
