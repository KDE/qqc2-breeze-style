/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import "impl" as Impl

T.Dialog {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            Math.ceil(contentWidth) + leftPadding + rightPadding,
                            implicitHeaderWidth,
                            implicitFooterWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             Math.ceil(contentHeight) + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    padding: Kirigami.Units.gridUnit

//     anchors.centerIn: T.Overlay.overlay

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    background: Rectangle {
        radius: Impl.Units.smallRadius
        color: Kirigami.Theme.backgroundColor
        border.color: Kirigami.Theme.separatorColor
        border.width: control.dim ? 0 : Impl.Units.smallBorder

        Impl.LargeShadow {
            radius: parent.radius
        }
    }

    header: Kirigami.Heading {
        text: control.title
        level: 2
        visible: control.title
        elide: Label.ElideRight
        padding: Kirigami.Units.gridUnit
        bottomPadding: 0
    }

    footer: DialogButtonBox {
        visible: count > 0
    }

    T.Overlay.modal: Impl.OverlayModalBackground {}
    T.Overlay.modeless: Impl.OverlayDimBackground {}
}
