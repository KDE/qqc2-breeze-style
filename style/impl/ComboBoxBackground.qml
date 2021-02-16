/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

/*
 * This file exists mainly because ComboBox's `highlighted` has the same name,
 * but a completely different meaning from Button's `highlighted`.
 *
 * ComboBox::highlighted(int index)
 * This signal is emitted when the item at index in the popup list is highlighted by the user.
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

Rectangle {
    id: mainBackground

    property alias control: mainBackground.parent

    property color flatColor: Qt.rgba(
        Kirigami.Theme.backgroundColor.r,
        Kirigami.Theme.backgroundColor.g,
        Kirigami.Theme.backgroundColor.b,
        0
    )
    property bool highlightBackground: control.down
    property bool highlightBorder: control.down || control.visualFocus || control.hovered

    implicitWidth: 120
    implicitHeight: Kirigami.Units.mediumControlHeight

    visible: !control.flat || control.editable || control.down || control.visualFocus || control.hovered

    color: {
        if (highlightBackground) {
            return Kirigami.Theme.alternateBackgroundColor
        } else if (control.flat) {
            return flatColor
        } else {
            return Kirigami.Theme.backgroundColor
        }
    }

    border {
        color: highlightBorder ?
            Kirigami.Theme.focusColor : Kirigami.Theme.buttonSeparatorColor
        width: Kirigami.Units.smallBorder
    }

    Behavior on color {
        enabled: highlightBackground
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }
    Behavior on border.color {
        enabled: highlightBorder
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    radius: Kirigami.Units.smallRadius

    SmallShadow {
        id: shadow
        opacity: control.down ? 0 : 1
        visible: !control.editable && !control.flat && control.enabled
        z: -1
        radius: parent.radius
    }

    FocusRect {
        id: focusRect
        baseRadius: mainBackground.radius
        visible: control.visualFocus
    }

    BackgroundGradient {
        id: bgGradient
        radius: mainBackground.radius
        opacity: !control.popup.visible && (control.down || control.hovered) ? 0 : 1
        visible: !control.editable && !control.flat && control.enabled
    }
}
