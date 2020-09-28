/*
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQml 2.15

// This exists because Qt Quick Controls don't all inherit the properties from Control
Item {
    id: root
    property Item control
    property bool usingControl: control ? true : false
    property bool enabled: usingControl && control.enabled
    property int focusReason: usingControl ? control.focusReason : Qt.NoFocusReason
    property bool activeFocus: usingControl && control.activeFocus
    property bool visualFocus: root.activeFocus && (root.focusReason == Qt.TabFocusReason || root.focusReason == Qt.BacktabFocusReason || root.focusReason == Qt.ShortcutFocusReason)
    property bool pressed: usingControl && control.pressed
    property bool down: root.pressed
    property bool checked: usingControl && control.checked
    property bool hovered: usingControl && control.hovered
    property bool highlighted: usingControl && control.highlighted
    property bool flat: usingControl && control.flat
}
