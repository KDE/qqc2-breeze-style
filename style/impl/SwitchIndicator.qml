/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import org.kde.kirigami 2.14 as Kirigami

Item {
    id: root

    property alias control: root.parent

    implicitWidth: implicitHeight*2
    implicitHeight: Kirigami.Units.inlineControlHeight

    x: control.text || control.icon.name ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
    y: control.topPadding + (control.availableHeight - height) / 2

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    Rectangle {
        id: background
        anchors {
            fill: parent
            margins: Math.floor(parent.height / 6)
        }
        radius: height / 2
        color: Kirigami.Theme.backgroundColor
        border {
            width: Kirigami.Units.smallBorder
            color: control.down || control.checked || control.highlighted ?
                Kirigami.Theme.highlightColor : Kirigami.Theme.separatorColor
        }
    }

    // Using ShadowedRectangle because it fills the background slighly better than Rectangle.
    // However, it does very slightly overlap with the background border. Give and take.
    Kirigami.ShadowedRectangle {
        id: fillEffectRect
        visible: width > handle.width/2 - anchors.margins
        color: Kirigami.Theme.alternateBackgroundColor
        radius: height/2
        anchors {
            left: background.left
            right: handle.horizontalCenter
            top: background.top
            bottom: background.bottom
            margins: background.border.width
        }
    }

    Rectangle {
        id: handle
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        // It's necessary to use x position instead of anchors so that the handle position can be dragged
        x: Math.max(
            0,
            Math.min(
                parent.width - width,
                control.visualPosition * parent.width - (width / 2)
            )
        )
        width: height
        radius: height / 2
        color: Kirigami.Theme.backgroundColor
        border {
            width: Kirigami.Units.smallBorder
            color: (control.down || control.highlighted || control.visualFocus || control.hovered) && control.enabled ?
                Kirigami.Theme.highlightColor : Kirigami.Theme.separatorColor
        }

        Behavior on x {
            /* Using SmoothedAnimation because the fill effect is anchored to the handle.
             * 
             * This animation runs sometimes when a page with Switches is loaded.
             * I should find a way to prevent that from happening.
             * At least it's unlikely that a single page will have a ridiculous amount of Switches.
             */
            SmoothedAnimation {
                duration: Kirigami.Units.shortDuration
                //SmoothedAnimations have a hardcoded InOutQuad easing
            }
        }

        SmallShadow {
            id: shadow
            visible: !control.flat && !control.down && control.enabled
            z: -1
            radius: parent.radius
        }

        FocusRect {
            baseRadius: handle.radius
            visible: control.visualFocus
        }
    }
}
