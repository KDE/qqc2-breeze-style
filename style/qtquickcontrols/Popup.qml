/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

T.Popup {
    id: control

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

//     contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
//     contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)

    padding: Kirigami.Units.largeSpacing
//     clip: true

    enter: Transition {
        OpacityAnimator {
            //property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.shortDuration
        }
    }

    exit: Transition {
        OpacityAnimator {
            //property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.shortDuration
        }
    }

    background: Kirigami.ShadowedRectangle {
        radius: 2
        color: Kirigami.Theme.backgroundColor

        property color borderColor: Kirigami.Theme.textColor
        border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        border.width: 1

        shadow.xOffset: 0
        shadow.yOffset: 4
        shadow.color: Qt.rgba(0, 0, 0, 0.3)
        shadow.size: 8
    }
}
