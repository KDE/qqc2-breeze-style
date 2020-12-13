/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import org.kde.breeze 1.0

IconLabelLayout {
    id: root

    property alias control: root.parent
    property bool reserveSpaceForIndicator: false
    property bool reserveSpaceForIcon: false
    property bool reserveSpaceForArrow: false

    icon: control.icon
    text: control.text
    font: control.font
    color: Kirigami.Theme.textColor

    property real padding: 0
    property real horizontalPadding: padding
    property real verticalPadding: padding
    leftPadding: {
        let lpad = horizontalPadding
        /*
        // Not needed since Qt 5.15.2
        if (root.mirrored) {
            return lpad
        }
        */
        if (control.indicator
            && (control.indicator.visible || reserveSpaceForIndicator)
            && control.indicator.width > 0
        ) {
            lpad += control.indicator.width + root.spacing
        }
        if (reserveSpaceForIcon && !iconVisible && control.icon.width > 0) {
            lpad += control.icon.width + root.spacing
        }
        return lpad
    }
    rightPadding: {
        let rpad = horizontalPadding
        /*
        // Not needed since Qt 5.15.2
        if (!root.mirrored) {
            return rpad
        }
        if (reserveSpaceForIcon && !icon.visible) {
            rpad += control.icon.width + root.spacing
        }
        */
        if (control.arrow && (control.arrow.visible || reserveSpaceForArrow) && control.arrow.width > 0) {
            rpad += control.arrow.width + root.spacing
        }
        return rpad
    }
    topPadding: verticalPadding
    bottomPadding: verticalPadding
    spacing: control.spacing

    mirrored: control.mirrored
    alignment: Qt.AlignCenter
    display: control.display

    iconComponent: Component {
        Kirigami.Icon {
            // This is set in IconLabelLayout
            property bool firstLayoutCompleted: false
            visible: valid
            Behavior on opacity {
                enabled: firstLayoutCompleted
                OpacityAnimator {
                    duration: Kirigami.Units.shortDuration
                }
            }
        }
    }

    labelComponent: Component {
        Controls.Label {
            // This is set in IconLabelLayout
            property bool firstLayoutCompleted: false
            visible: text.length > 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            Behavior on x {
                enabled: firstLayoutCompleted
                XAnimator {
                    duration: Kirigami.Units.shortDuration
                }
            }
            Behavior on y {
                enabled: firstLayoutCompleted
                YAnimator {
                    duration: Kirigami.Units.shortDuration
                }
            }
            Behavior on opacity {
                enabled: firstLayoutCompleted
                OpacityAnimator {
                    duration: Kirigami.Units.shortDuration
                }
            }
        }
    }
}
