/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.TabButton {
    id: control

    readonly property bool __inHeader: T.TabBar.position === T.TabBar.Header
    readonly property bool __inFooter: T.TabBar.position === T.TabBar.Footer

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.mediumSpacing
    leftPadding: {
        if ((!contentItem.hasIcon && contentItem.textBesideIcon) // False if contentItem has been replaced
            || display == T.AbstractButton.TextOnly
            || display == T.AbstractButton.TextUnderIcon) {
            return Kirigami.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    rightPadding: {
        if (contentItem.hasLabel && display != T.AbstractButton.IconOnly) { // False if contentItem has been replaced
            return Kirigami.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto

    Kirigami.Theme.colorSet: control.checked || control.down ? Kirigami.Theme.Button : (T.TabBar.tabBar.Kirigami.Theme.colorSet ?? Kirigami.Theme.Button)
    Kirigami.Theme.inherit: !(background && background.visible)

    contentItem: IconLabelContent {
        control: control
    }

    //TODO: tweak the appearance. This is just to have something usable and reasonably close to what we want.
    background: Kirigami.ShadowedRectangle {
//         visible: control.checked
//             && !(control.ListView.view
//                 && control.ListView.view.highlightItem
//                 && control.ListView.view.highlightItem.visible)
        implicitHeight: Kirigami.Units.mediumControlHeight
        implicitWidth: implicitHeight
        color: control.checked || control.down ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor

        Rectangle {
            id: separatorLine
            anchors {
                left: parent.left
                right: parent.right
                top: control.__inFooter ? parent.top : undefined
                bottom: control.__inHeader ? parent.bottom : undefined
            }
            height: control.checked ? Kirigami.Units.highlightLineThickness : 1
            color: control.hovered || control.checked || control.visualFocus ? Kirigami.Theme.focusColor : Kirigami.Theme.separatorColor
        }
    }
}
