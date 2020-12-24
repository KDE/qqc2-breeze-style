/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.TabButton {
    id: control

    readonly property bool __inHeader: Controls.TabBar.position === Controls.TabBar.Header
    readonly property bool __inFooter: Controls.TabBar.position === Controls.TabBar.Footer

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.mediumSpacing
    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: !(background && background.visible)

    contentItem: IconLabelContent {
        control: control
    }

    //TODO: tweak the appearance. This is just to have something usable and reasonably close to what we want.
    background: Rectangle {
        visible: control.checked
        implicitHeight: Kirigami.Units.mediumControlHeight
        implicitWidth: implicitHeight
        color: Kirigami.Theme.alternateBackgroundColor
        Rectangle {
            id: line
            anchors {
                left: parent.left
                right: parent.right
                top: control.__inFooter ? parent.top : undefined
                bottom: control.__inHeader ? parent.bottom : undefined
            }
            height: Kirigami.Units.highlightLineThickness
            color: Kirigami.Theme.focusColor
        }
    }
}
