/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

T.SwipeDelegate {
    id: control

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

    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.sizeForLabels
    icon.height: Kirigami.Units.iconSizes.sizeForLabels

    Kirigami.Theme.colorSet: control.down || control.highlighted ? Kirigami.Theme.Button : -1
    Kirigami.Theme.inherit: !background || !background.visible && !(control.highlighted || control.down)

    contentItem:Impl.IconLabelContent {
        control: control
        text: control.text
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        //color: (control.pressed && !control.checked && !control.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    }

    background: Impl.DelegateBackground {
        control: control
    }

    clip: true
    swipe.transition: Transition {
        SmoothedAnimation {
            velocity: 3
            easing.type: Easing.InOutCubic
        }
    }
}
