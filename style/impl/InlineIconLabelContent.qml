/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import org.kde.kirigami as Kirigami

import "." as Impl

IconLabelContent {
    id: root
    Impl.StandardRectangle {
        z: -1
        x: root.labelRect.x
        y: root.labelRect.y + root.labelRect.height - height
        width: root.labelRect.width//root.hasIcon && root.hasLabel ? root.availableWidth - root.icon.width - root.spacing : root.availableWidth
        height: Impl.Units.focusUnderlineThickness
        visible: control.visualFocus
        color: Kirigami.Theme.focusColor
    }
}
