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

    contentItem: TextInput {
        z: 2
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
    }
}
