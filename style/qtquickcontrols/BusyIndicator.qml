/* SPDX-FileCopyrightText: 2018 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-FileCopyrightText: 2022 ivan tkachenko <me@ratijas.tk>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

T.BusyIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    // BusyIndicator doesn't need padding since it has no background.
    // A Control containing a BusyIndicator can have padding instead
    // (e.g., a ToolBar, a Page or maybe a widget in a Plasma panel).
    padding: 0

    hoverEnabled: false

    contentItem: Item {
        /* Binding on `visible` implicitly takes care of `control.visible`,
         * `control.running` and `opacity > 0` at once.
         * Also, don't animate at all if the user has disabled animations,
         * and don't animate when window is hidden (which somehow does not
         * affect items' visibility).
         */
        readonly property bool animationShouldBeRunning:
            visible
            && Window.visibility !== Window.Hidden
            && Kirigami.Units.longDuration > 1

        /* implicitWidth and implicitHeight won't work unless they come
         * from a child of the contentItem. No idea why.
         */
        implicitWidth: Kirigami.Units.gridUnit * 2
        implicitHeight: Kirigami.Units.gridUnit * 2

        // We can't bind directly to opacity, as Animator won't update its value immediately.
        visible: control.running || opacityAnimator.running
        opacity: control.running ? 1 : 0
        Behavior on opacity {
            enabled: Kirigami.Units.shortDuration > 0
            OpacityAnimator {
                id: opacityAnimator
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutCubic
            }
        }

        // sync all busy animations such that they start at a common place in the rotation
        onAnimationShouldBeRunningChanged: startOrStopAnimation();

        function startOrStopAnimation() {
            if (rotationAnimator.running === animationShouldBeRunning) {
                return;
            }
            if (animationShouldBeRunning) {
                const date = new Date;
                const ms = date.valueOf();
                const startAngle = ((ms % rotationAnimator.duration) / rotationAnimator.duration) * 360;
                rotationAnimator.from = startAngle;
                rotationAnimator.to = startAngle + 360
            }
            rotationAnimator.running = animationShouldBeRunning;
        }

        Kirigami.Icon {
            /* Do not use `anchors.fill: parent` in here or else
             * the aspect ratio won't always be 1:1.
             */
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width

            source: "process-working-symbolic"
            smooth: true

            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                // Not using a standard duration value because we don't want the
                // animation to spin faster or slower based on the user's animation
                // scaling preferences; it doesn't make sense in this context
                duration: 2000
                loops: Animation.Infinite
                // Initially false, will be set as appropriate after
                // initialization. Can't be bound declaratively due to the
                // procedural nature of to/from adjustments: order of
                // assignments is crucial, as animator won't use new to/from
                // values while running.
                running: false
            }
        }

        Component.onCompleted: startOrStopAnimation();
    }
}
