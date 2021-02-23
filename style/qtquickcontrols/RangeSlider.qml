/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later OR LicenseRef-KDE-Accepted-LGPL OR LicenseRef-KFQF-Accepted-GPL
 */


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.16 as Kirigami
import "impl"

T.RangeSlider {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            Math.max(first.implicitHandleWidth,
                                     second.implicitHandleWidth) + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             Math.max(first.implicitHandleHeight,
                                      second.implicitHandleHeight) + topPadding + bottomPadding)

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.mediumSpacing : 0

    first.handle: SliderHandle {
        control: control
        position: control.first.position
        visualPosition: control.first.visualPosition
        hovered: first.hovered
        pressed: first.pressed
        // For some reason, this doesn't need focusReason to work correctly even though focusReason doesn't work on this
        visualFocus: activeFocus
    }

    second.handle: SliderHandle {
        control: control
        position: control.second.position
        visualPosition: control.second.visualPosition
        hovered: second.hovered
        pressed: second.pressed
        // For some reason, this doesn't need focusReason to work correctly even though focusReason doesn't work on this
        visualFocus: activeFocus
    }

    background: SliderGroove {
        control: control
        startPosition: first.position
        endPosition: second.position
    }
}
