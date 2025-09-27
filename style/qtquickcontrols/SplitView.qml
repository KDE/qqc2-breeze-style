/* SPDX-FileCopyrightText: 2018 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2024 ivan tkachenko <me@ratijas.tk>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

T.SplitView {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    handle: Kirigami.Separator {
        id: handle

        // Increase the hit area
        containmentMask: Item {
            // Dynamic margins like in Breeze/SplitterProxy
            readonly property int handleMargin: control.handle.T.SplitHandle.hovered ? 12 : 6

            x: control.orientation === Qt.Vertical ? 0 : -handleMargin
            y: control.orientation === Qt.Horizontal ? 0 : -handleMargin

            width: handle.width + (control.orientation === Qt.Vertical ? 0 : handleMargin * 2)
            height: handle.height + (control.orientation === Qt.Horizontal ? 0 : handleMargin * 2)
        }
    }
}
