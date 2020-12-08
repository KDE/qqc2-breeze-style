/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.SpinBox {
    id: control
    property real __downIndicatorWidth: down.indicator ? down.indicator.width : 0
    property real __upIndicatorWidth: up.indicator ? up.indicator.width : 0
    property real __leftIndicatorWidth: control.mirrored ? __upIndicatorWidth : __downIndicatorWidth
    property real __rightIndicatorWidth: control.mirrored ? __downIndicatorWidth : __upIndicatorWidth

    implicitWidth: Math.max(
        implicitBackgroundWidth + leftInset + rightInset,
        Math.max(implicitContentWidth + leftPadding + rightPadding, down.implicitIndicatorWidth-2)
            + up.implicitIndicatorWidth
            + down.implicitIndicatorWidth
    )
    implicitHeight: Math.max(
        implicitBackgroundHeight + topInset + bottomInset,
        implicitContentHeight + topPadding + bottomPadding,
        up.implicitIndicatorHeight,
        down.implicitIndicatorHeight
    )

    Kirigami.Theme.colorSet: control.editable ? Kirigami.Theme.View : Kirigami.Theme.Button
    Kirigami.Theme.inherit: !Boolean(background)

    editable: true
    inputMethodHints: Qt.ImhDigitsOnly

    padding: Kirigami.Units.mediumSpacing
    spacing: Kirigami.Units.mediumSpacing

    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    down.indicator: SpinBoxIndicator {
        button: control.down
        alignment: Qt.AlignLeft
        mirrored: control.mirrored
    }

    /* NOTE: There is a flaw in QQC2 SpinBox with how focus is handled.
     * Unless you make the TextInput unfocusable (not what you want),
     * you can't detect whether or not a spinbox has activeFocus or visualFocus.
     * This is because the TextInput takes the focus.
     * In order to detect if a SpinBox is focused, you must trust that the
     * contentItem will be the part that takes the focus.
     */

    contentItem: T.TextField {
        z: 2
        // Intentionally using anchors so that left/right
        // control padding can be used like it normally would
        anchors {
            fill: parent
            leftMargin: control.__leftIndicatorWidth
            rightMargin: control.__rightIndicatorWidth
        }
        text: control.displayText
        font: control.font
        color: Kirigami.Theme.textColor
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints
        selectByMouse: true // Should this be disabled for mobile?
    }

    up.indicator: SpinBoxIndicator {
        button: control.up
        alignment: Qt.AlignRight
        mirrored: control.mirrored
    }

    background: TextEditBackground {
        control: control
        // Work around SpinBox focus handling flaw
        visualFocus: control.visualFocus || (control.contentItem.activeFocus && (
            control.contentItem.focusReason == Qt.TabFocusReason ||
            control.contentItem.focusReason == Qt.BacktabFocusReason ||
            control.contentItem.focusReason == Qt.ShortcutFocusReason
        ))
    }
}
