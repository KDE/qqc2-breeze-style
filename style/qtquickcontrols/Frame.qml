/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.19 as Kirigami

import "impl" as Impl

T.Frame {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            Math.ceil(contentWidth) + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             Math.ceil(contentHeight) + topPadding + bottomPadding)

//     contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
    //contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)

    padding: Impl.Units.veryLargeSpacing + Impl.Units.smallBorder

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        radius: Impl.Units.smallRadius
        border.color: Kirigami.Theme.separatorColor
        border.width: Impl.Units.smallBorder
    }
}
