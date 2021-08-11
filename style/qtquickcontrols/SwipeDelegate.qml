/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

import "impl" as Impl

T.SwipeDelegate {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: Impl.Units.mediumSpacing
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

    spacing: Impl.Units.mediumSpacing

    icon.width: Impl.Units.iconSizes.auto
    icon.height: Impl.Units.iconSizes.auto

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
