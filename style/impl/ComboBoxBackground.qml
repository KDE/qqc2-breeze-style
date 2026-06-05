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

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import "." as Impl

Impl.StandardRectangle {
    id: mainBackground

    required property T.ComboBox control

    property bool highlightBackground: control.down
    property bool highlightBorder: control.down || control.visualFocus || control.hovered

    implicitWidth: 200
    implicitHeight: Impl.Units.mediumControlHeight

    visible: !control.flat || control.editable || control.down || control.visualFocus || control.hovered

    color: {
        if (highlightBackground) {
            return palette.highlight
        } else {
            return palette.button
        }
    }

    border {
        color: highlightBorder ?
            palette.highlight : Impl.Theme.buttonSeparatorColor()
        width: Impl.Units.smallBorder
    }

    Behavior on color {
        enabled: mainBackground.highlightBackground
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }
    Behavior on border.color {
        enabled: mainBackground.highlightBorder
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }

    radius: Impl.Units.smallRadius

    SmallBoxShadow {
        id: shadow
        opacity: mainBackground.control.down ? 0 : 1
        visible: !mainBackground.control.editable && !mainBackground.control.flat && mainBackground.control.enabled
        radius: parent.radius
    }

    FocusRect {
        id: focusRect
        baseRadius: mainBackground.radius
        visible: mainBackground.control.visualFocus
    }
}
