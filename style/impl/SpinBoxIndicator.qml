/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.14 as Kirigami

import "." as Impl

Item {
    id: root

    property QtObject button // QQuickSpinButton is a QObject
    property bool mirrored: false
    property int alignment: Qt.AlignLeft
    property bool leftAligned: root.alignment == Qt.AlignLeft
    property bool rightAligned: root.alignment == Qt.AlignRight
    property real leftRadius: {
        if ((leftAligned && !mirrored)
            || (rightAligned && mirrored)) {
            return Impl.Units.smallRadius
        } else {
            return 0
        }
    }
    property real rightRadius: {
        if ((rightAligned && !mirrored)
            || (leftAligned && mirrored)) {
            return Impl.Units.smallRadius
        } else {
            return 0
        }
    }

    x: {
        if ((leftAligned && !mirrored)
            || (rightAligned && mirrored)) {
            return 0
        } else {
            return parent.width - width
        }
    }
    height: parent.height

    implicitWidth: implicitHeight
    implicitHeight: Impl.Units.mediumControlHeight

    Rectangle {
        id: separator
        width: Impl.Units.smallBorder
        x: {
            if ((leftAligned && !mirrored)
                || (rightAligned && mirrored)) {
                return parent.width - width
            } else {
                return 0
            }
        }
        anchors {
            top: parent.top
            bottom: parent.bottom
            topMargin: Impl.Units.smallSpacing
            bottomMargin: Impl.Units.smallSpacing
        }

        color: button.pressed || button.hovered ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor

        Behavior on color {
            enabled: button.pressed || button.hovered
            ColorAnimation {
                duration: Impl.Units.shortDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Kirigami.ShadowedRectangle {
        id: pressedBg
        Kirigami.Theme.colorSet: Kirigami.Theme.Button
        Kirigami.Theme.inherit: false
        opacity: 0
        anchors.fill: parent
        color: Kirigami.Theme.alternateBackgroundColor
        corners {
            topLeftRadius: root.leftRadius
            topRightRadius: root.rightRadius
            bottomLeftRadius: root.leftRadius
            bottomRightRadius: root.rightRadius
        }
        border.color: Kirigami.Theme.focusColor
        border.width: Impl.Units.smallBorder

        states: State {
            name: "pressed"
            when: button.pressed
            PropertyChanges {
                target: pressedBg
                opacity: 1
                visible: true
            }
        }
        transitions: Transition {
            from: "pressed"
            to: ""
            SequentialAnimation {
                OpacityAnimator {
                    duration: Impl.Units.shortDuration
                    easing.type: Easing.OutCubic
                }
                PropertyAction {
                    target: pressedBg
                    property: "visible"
                    value: false
                }
            }
        }
    }

    Kirigami.Icon {
        implicitHeight: Impl.Units.iconSizes.auto
        implicitWidth: implicitHeight
        anchors {
            centerIn: parent
        }
        source: {
            // For some reason I don't need to use the fancier logic with this
            if (leftAligned) {
                return "arrow-down"
            } else {
                return "arrow-up"
            }
        }
    }
}
