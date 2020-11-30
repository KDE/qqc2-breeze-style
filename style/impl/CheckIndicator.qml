/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import org.kde.breeze 1.0

Rectangle {
    id: root

    property alias control: root.parent
    property int checkState: control.checkState
    property int symbolSize: {
        let s = Math.min(root.height, root.width)
        s = s - s%6
        s = s - s/3
        return s
    }

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
        height: root.symbolSize + penWidth
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
        width: root.symbolSize
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

    FocusRect {
        baseRadius: root.radius
        visible: control.visualFocus
    }

    Rectangle {
        id: sidewaysRevealRect
        anchors {
            right: checkmark.right
            top: checkmark.top
            bottom: checkmark.bottom
        }
        width: 0
        visible: width > 0
        color: root.color
    }

    NumberAnimation {
        id: sidewaysRevealAnimation
        target: sidewaysRevealRect
        property: "width"
        from: checkmark.width
        to: 0
        duration: Kirigami.Units.shortDuration
        //Intentionally not using an easing curve
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

    /* I'm using this instead of transitions because I couldn't reliably
     * trigger the animation when going from the partiallychecked state to the
     * checked state.
     */
    onStateChanged: {
        /* Prevents the transition from running when the parent control is created.
         * This can reduce resource usage spikes on pages that have way too many checkboxes.
         */
        if (state == "checked" || state == "partiallychecked") {
            // equivalent to stop(), then start()
            sidewaysRevealAnimation.restart()
        }
    }
}
