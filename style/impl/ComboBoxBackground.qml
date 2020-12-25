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

    implicitWidth: 120
    implicitHeight: Kirigami.Units.mediumControlHeight

    visible: !control.flat || control.editable || control.down || control.checked || control.visualFocus || control.hovered

    color: {
        if (!control.popup.visible && (control.down || control.checked) ) {
            Kirigami.Theme.alternateBackgroundColor
        } else if (control.flat) {
            Qt.rgba(
                Kirigami.Theme.backgroundColor.r,
                Kirigami.Theme.backgroundColor.g,
                Kirigami.Theme.backgroundColor.b,
                0)
        } else {
            Kirigami.Theme.backgroundColor
        }
    }

    border {
        color: control.down || control.checked || control.visualFocus || control.hovered ?
            Kirigami.Theme.focusColor : Kirigami.Theme.buttonSeparatorColor
//             Kirigami.ColorUtils.tintWithAlpha(mainBackground.color, Kirigami.Theme.textColor, 0.3)
        width: Kirigami.Units.smallBorder
    }

    Behavior on color {
        ColorAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutCubic
        }
    }
    Behavior on border.color {
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
        opacity: control.down || control.hovered ? 0 : 1
        visible: !control.editable && !control.flat && control.enabled
    }
}
