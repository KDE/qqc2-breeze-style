/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.RadioDelegate {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.mediumSpacing
    leftPadding: !contentItem.hasIcon && !control.indicator ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding
    rightPadding: contentItem.hasLabel ? Kirigami.Units.mediumHorizontalPadding : control.horizontalPadding

    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto
    
    Kirigami.Theme.colorSet: control.highlighted || control.down ? Kirigami.Theme.Selection : parent.Kirigami.Theme.colorSet
    Kirigami.Theme.inherit: !(control.highlighted || control.down)

    contentItem: IconLabelContent {
        control: control
        text: control.text
        //color: (control.pressed && !control.checked && !control.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    }

    indicator: RadioIndicator {
        control: control
    }

    background: DelegateBackground {
        control: control
    }
}
