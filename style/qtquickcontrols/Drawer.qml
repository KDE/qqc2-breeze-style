/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LicenseRef-KDE-Accepted-LGPL
 */


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.Drawer {
    id: control

    palette: Kirigami.Theme.palette
    parent: T.ApplicationWindow.overlay

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
    contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)

    topPadding: control.edge === Qt.BottomEdge ? 1 : 0
    leftPadding: control.edge === Qt.RightEdge ? 1 : 0
    rightPadding: control.edge === Qt.LeftEdge ? 1 : 0
    bottomPadding: control.edge === Qt.TopEdge ? 1 : 0

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        Rectangle {
            anchors {
               left: control.edge !== Qt.LeftEdge ? parent.left : undefined
               right: control.edge !== Qt.RightEdge ? parent.right : undefined
               top: control.edge !== Qt.TopEdge ? parent.top : undefined
               bottom: control.edge !== Qt.BottomEdge ? parent.bottom : undefined
            }
            color: Kirigami.Theme.separatorColor
            implicitWidth: 1
            implicitHeight: 1
        }
    }

    enter: Transition {
        SmoothedAnimation {
            velocity: 5
        }
    }
    exit: Transition {
        SmoothedAnimation {
            velocity: 5
        }
    }

    T.Overlay.modal: OverlayModalBackground {}
    T.Overlay.modeless: OverlayDimBackground {}
}
