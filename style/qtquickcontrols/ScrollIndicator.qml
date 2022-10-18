/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.19 as Kirigami

import "impl" as Impl

T.ScrollIndicator {
    id: control

    // content may be loaded after this component, ensure it always stays above content
    // inline with qqc2-desktop-style behaviour
    z: 9999

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    visible: control.size < 1

    minimumSize: horizontal ? height / width : width / height

    padding: Impl.Units.verySmallSpacing

    contentItem: Impl.ScrollHandle {
        control: control
    }
}
