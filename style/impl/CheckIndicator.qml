/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import org.kde.kirigami 2.14 as Kirigami
import org.kde.breeze 1.0

Rectangle {
    id: root

    property alias control: root.parent
    property int checkState: control.checkState

    visible: control.checkable

    x: control.text || control.icon.name ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
    y: control.topPadding + (control.availableHeight - height) / 2

    implicitWidth: implicitHeight
    implicitHeight: Kirigami.Units.inlineControlHeight

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false
    color: control.enabled && control.down || root.checkState !== Qt.Unchecked ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor

    radius: Kirigami.Units.smallRadius

    border {
        width: Kirigami.Units.smallBorder
        color: control.enabled && control.down || root.checkState !== Qt.Unchecked || control.highlighted || control.visualFocus || control.hovered ?
            Kirigami.Theme.highlightColor : Kirigami.Theme.separatorColor
            //Kirigami.ColorUtils.tintWithAlpha(root.color, Kirigami.Theme.textColor, 0.3)
    }

    SmallShadow {
        id: shadow
        visible: !control.editable && !control.flat && !control.down && control.enabled
        z: -1
        radius: parent.radius
    }

    PaintedSymbol {
        id: checkmark
        anchors.centerIn: parent
        // Should reliably create pixel aligned checkmarks that don't get cut off on the sides.
        height: {
            let h = root.height - root.height%6
            h = h - h/3 + penWidth
            return h
        }
        width: height
        color: Kirigami.Theme.textColor
        symbolType: PaintedSymbol.Checkmark
        visible: root.checkState === Qt.Checked

        /* RTL support. Horizontally flips the checkmark.
         * Is this actually a good idea for checkmarks?
        transform: control.mirrored ? horizontalFlipMatrix : null

        Matrix4x4 {
            id: horizontalFlipMatrix
            matrix: Qt.matrix4x4(
                -1, 0, 0, checkmark.width,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            )
        }
        */
    }

    Item {
        id: partialCheckmark
        visible: root.checkState === Qt.PartiallyChecked
        anchors.centerIn: parent
        width: {
            let w = root.width - root.width%6
            w = w - w/3
            return w
        }
        height: 2

        Rectangle {
            id: leftRect
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: height
            color: Kirigami.Theme.textColor
        }

        Rectangle {
            id: middleRect
            anchors.centerIn: parent
            height: parent.height
            width: height
            color: Kirigami.Theme.textColor
        }

        Rectangle {
            id: rightRect
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: height
            color: Kirigami.Theme.textColor
        }
    }

    Rectangle {
        id: sidewaysRevealRect
        anchors {
            right: root.right
            top: root.top
            bottom: root.bottom
            margins: root.border.width
        }
        width: 0
        visible: width > 0
        color: root.color
        radius: root.radius - root.border.width
    }

    FocusRect {
        baseRadius: root.radius
        visible: control.visualFocus
    }

    states: [
        State {
            name: "unchecked"
            when: root.checkState === Qt.Unchecked
        },
        State {
            name: "checked"
            when: root.checkState === Qt.Checked
        },
        State {
            name: "partiallychecked"
            when: root.checkState === Qt.PartiallyChecked
        }
    ]

    NumberAnimation {
        id: sidewaysRevealAnimation
        target: sidewaysRevealRect
        property: "width"
        from: root.width - root.border.width*2
        to: 0
        duration: Kirigami.Units.shortDuration
        //Intentionally not using an easing curve
    }

    transitions: [
        /* Using `from: "state,state"` instead of `from: "*"` prevents the
         * transition from running when the parent control is created.
         * This can reduce resource usage spikes on pages that have way too many checkboxes.
         */
        Transition {
            from: "unchecked,partiallychecked"
            to: "checked"
            animations: sidewaysRevealAnimation
        },
        Transition {
            from: "unchecked,checked"
            to: "partiallychecked"
            animations: sidewaysRevealAnimation
        }
    ]
}
