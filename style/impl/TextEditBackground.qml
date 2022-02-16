/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.19 as Kirigami

import "." as Impl

Rectangle {
    id: root

    property Item control: root.parent
    property bool visualFocus: control.activeFocus && (
        control.focusReason == Qt.TabFocusReason ||
        control.focusReason == Qt.BacktabFocusReason ||
        control.focusReason == Qt.ShortcutFocusReason
    )

    implicitWidth: implicitHeight
    implicitHeight: Impl.Units.mediumControlHeight

    color: Kirigami.Theme.backgroundColor
    radius: Impl.Units.smallRadius
    border {
        color: control.activeFocus || control.hovered ?
            Kirigami.Theme.focusColor : Kirigami.Theme.buttonSeparatorColor
        width: Impl.Units.smallBorder
    }

    FocusRect {
        visible: root.visualFocus
        baseRadius: parent.radius
    }

    Behavior on border.color {
        enabled: control.activeFocus || control.hovered
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }
}
