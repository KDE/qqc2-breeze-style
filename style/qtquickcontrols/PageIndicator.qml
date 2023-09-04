/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import "impl" as Impl

T.PageIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.mediumSpacing
    spacing: Kirigami.Units.mediumSpacing

    // Using ShadowedRectangle because it makes smoother circles than Rectangle
    delegate: Kirigami.ShadowedRectangle {
        implicitWidth: implicitHeight
        implicitHeight: {
            let h = Impl.Units.inlineControlHeight/2
            h -= h % 2
            return h
        }

        radius: height / 2
        color: Kirigami.Theme.textColor

        opacity: index === currentIndex ? 1 : pressed ? 0.67 : 0.33
        Behavior on opacity { OpacityAnimator { duration: Kirigami.Units.shortDuration } }
    }

    contentItem: Row {
        spacing: control.spacing

        Repeater {
            model: control.count
            delegate: control.delegate
        }
    }
}
