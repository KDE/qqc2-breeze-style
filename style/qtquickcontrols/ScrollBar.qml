/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

import "impl" as Impl

T.ScrollBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: control.interactive ? Impl.Units.mediumSpacing : Impl.Units.verySmallSpacing
    leftPadding: horizontalPadding + separator.thickness

    visible: control.size < 1 && control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: horizontal ? height / width : width / height

    interactive: !Kirigami.Settings.hasTransientTouchInput

    policy: Kirigami.Settings.isMobile || !control.interactive ? T.ScrollBar.AsNeeded : T.ScrollBar.AlwaysOn

    contentItem: Impl.ScrollHandle {
        control: control
        policy: control.policy
        pressed: control.pressed
    }

    background: Rectangle {
        visible: control.policy === T.ScrollBar.AlwaysOn
        color: "transparent"
        Kirigami.Separator {
            id: separator
            property int thickness: parent.visible ? Math.min(width, height) : 0
            weight: Kirigami.Separator.Weight.Light
            anchors {
                left: parent.left
                right: control.horizontal ? parent.right : undefined
                top: parent.top
                bottom: control.vertical ? parent.bottom : undefined
            }
        }
    }
}
