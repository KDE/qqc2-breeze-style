/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.ProgressBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: Kirigami.Units.grooveHeight
        clip: true
        Rectangle {
            id: progressFill
            visible: !control.indeterminate && width > 0
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: control.position * parent.width

            radius: Kirigami.Units.grooveHeight/2
            color: Kirigami.Theme.alternateBackgroundColor
            border {
                width: Kirigami.Units.smallBorder
                color: Kirigami.Theme.focusColor
            }
        }

        /*Item {
            id: indeterminateFill
            //TODO: Make this look like the indeterminate fill from the Breeze QStyle
            // or come up with something better.
        }*/
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: Kirigami.Units.grooveHeight

        radius: Kirigami.Units.grooveHeight/2
        color: Kirigami.Theme.backgroundColor
        border {
            width: Kirigami.Units.smallBorder
            color: Kirigami.Theme.separatorColor
        }
    }
}
