/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.SwitchDelegate {
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
            return Kirigami.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    rightPadding: {
        if (!control.indicator.visible
            && contentItem.hasLabel
            && display != T.AbstractButton.IconOnly) { // False if contentItem has been replaced
            return Kirigami.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }

    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto

    Kirigami.Theme.colorSet: control.down || control.highlighted ? Kirigami.Theme.Button : -1
    Kirigami.Theme.inherit: !background || !background.visible && !(control.highlighted || control.down)

    contentItem: IconLabelContent {
        control: control
        alignment: Qt.AlignLeft | Qt.AlignVCenter
        //color: (control.pressed && !control.checked && !control.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    }

    indicator: SwitchIndicator {
        control: control
        mirrored: !control.mirrored
    }

    background: DelegateBackground {
        control: control
    }
}
