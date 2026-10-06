// NOTE: check this

import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.breeze.impl as Impl

T.ScrollView {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: !background || !background.visible

    background: Impl.StandardRectangle {
        visible: control.Kirigami.StyleHints.showFramedBackground
        color: Kirigami.Theme.backgroundColor
        radius: Impl.Units.smallRadius
        border.color: Impl.Theme.separatorColor()
        border.width: Impl.Units.smallBorder
    }

    padding: background?.visible ? Impl.Units.smallBorder : 0

    data: [
        Kirigami.WheelHandler {
            target: control.contentItem
        }
    ]

    rightPadding: {
        if (ScrollBar.vertical?.background?.visible) {
            return ScrollBar.vertical.background.width + horizontalPadding
        } else {
            return horizontalPadding
        }
    }
    bottomPadding: {
        if (ScrollBar.horizontal?.background?.visible) {
            return ScrollBar.horizontal.background.height + verticalPadding
        } else {
            return verticalPadding
        }
    }

    ScrollBar.vertical: ScrollBar {
        parent: control
        x: control.mirrored ? 0 : control.width - width
        y: control.topPadding
        height: control.availableHeight
        active: control.ScrollBar.horizontal.active
    }

    ScrollBar.horizontal: ScrollBar {
        parent: control
        x: control.leftPadding
        y: control.height - height
        width: control.availableWidth
        active: control.ScrollBar.vertical.active
    }
}
