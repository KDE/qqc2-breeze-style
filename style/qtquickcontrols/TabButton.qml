/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.19 as Kirigami
import org.kde.breeze 1.0
import "impl" as Impl

T.TabButton {
    id: control

    readonly property bool __inTabBar: T.TabBar.tabBar != null
    readonly property bool __hasLeftSeparator: background && background.hasOwnProperty("leftSeparatorLine")
    readonly property bool __hasRightSeparator: background && background.hasOwnProperty("rightSeparatorLine")
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
            return Impl.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    rightPadding: {
        if (contentItem.hasLabel && display != T.AbstractButton.IconOnly) { // False if contentItem has been replaced
            return Impl.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }

    leftInset: {
        if (!mirrored && __hasLeftSeparator && background.leftSeparatorLine.visible) {
            return background.leftSeparatorLine.width
        } else if (mirrored && __hasRightSeparator && background.rightSeparatorLine.visible) {
            return background.rightSeparatorLine.width
        } else {
            return 0
        }
    }
    rightInset: {
        if (!mirrored && __hasRightSeparator && background.leftSeparatorLine.visible) {
            return background.rightSeparatorLine.width
        } else if (mirrored && __hasLeftSeparator && background.rightSeparatorLine.visible) {
            return background.leftSeparatorLine.width
        } else {
            return 0
        }
    }

    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.sizeForLabels
    icon.height: Kirigami.Units.iconSizes.sizeForLabels

    Kirigami.Theme.colorSet: {
        if (control.__inTabBar && !(control.checked)) {
            return T.TabBar.tabBar.Kirigami.Theme.colorSet
        } else {
            return Kirigami.Theme.Button
        }
    }
    Kirigami.Theme.inherit: !(background && background.visible)

    contentItem:Impl.IconLabelContent {
        control: control
    }

    //TODO: tweak the appearance. This is just to have something usable and reasonably close to what we want.
    background: Rectangle {
        implicitHeight: Impl.Units.mediumControlHeight + (Kirigami.Units.smallSpacing * 2) // fill TabBar
        implicitWidth: implicitHeight
        color: control.checked ? Kirigami.Theme.backgroundColor : "transparent"

        property Rectangle leftSeparatorLine: Rectangle {
            parent: control.background
            visible: control.T.TabBar.index != 0 && control.checked
            Kirigami.Theme.colorSet: Kirigami.Theme.Button
            Kirigami.Theme.inherit: false
            anchors.left: parent.left
            anchors.leftMargin: -control.leftInset
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: control.checked ? parent.height : Math.min(parent.height, Kirigami.Units.gridUnit)
            color: Kirigami.Theme.separatorColor
            Behavior on height {
                NumberAnimation {
                    easing.type: Easing.InOutQuad
                    duration: Kirigami.Units.longDuration
                }
            }
        }

        property Rectangle rightSeparatorLine: Rectangle {
            parent: control.background
            visible: control.__inTabBar && control.T.TabBar.index != control.T.TabBar.tabBar.count - 1 && control.checked
            Kirigami.Theme.colorSet: Kirigami.Theme.Button
            Kirigami.Theme.inherit: false
            anchors.right: parent.right
            anchors.rightMargin: -control.rightInset
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: parent.leftSeparatorLine.height
            color: Kirigami.Theme.separatorColor
        }

        Rectangle {
            id: thickHighlightLine
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: -control.leftInset
            anchors.rightMargin: -control.rightInset
            y: control.__inHeader ? 0 : parent.height - height
            height: Impl.Units.highlightLineThickness
            opacity: control.visualFocus || control.checked || control.hovered || control.down ? 1 : 0
            Kirigami.Theme.colorSet: Kirigami.Theme.Button
            Kirigami.Theme.inherit: false
            color: {
                if (control.visualFocus) {
                    Kirigami.Theme.alternateBackgroundColor
                } else if (control.checked || control.down) {
                    Kirigami.Theme.focusColor
                } else {
                    Kirigami.Theme.separatorColor
                }
            }
            Behavior on opacity {
                OpacityAnimator {
                    easing.type: Easing.OutCubic
                    duration: Kirigami.Units.shortDuration
                }
            }
            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.InOutQuad
                    duration: Kirigami.Units.longDuration
                }
            }
        }

        Rectangle {
            id: thinHighlightLine
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: -control.leftInset
            anchors.rightMargin: -control.rightInset
            y: control.__inHeader ? 0 : parent.height - height
            height: 1
            opacity: control.visualFocus ? 1 : 0
            Kirigami.Theme.colorSet: Kirigami.Theme.Button
            Kirigami.Theme.inherit: false
            color: Kirigami.Theme.focusColor
            Behavior on opacity {
                OpacityAnimator {
                    easing.type: Easing.OutCubic
                    duration: Kirigami.Units.shortDuration
                }
            }
        }
    }
}
