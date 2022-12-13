// NOTE: check this
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T

T.ScrollView {
    id: control
    clip: true //TODO: remove with Qt 6

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    rightPadding: {
        if (ScrollBar.vertical
            && ScrollBar.vertical.background
            && ScrollBar.vertical.background.visible
        ) {
            return ScrollBar.vertical.background.width
        } else {
            return horizontalPadding
        }
    }
    bottomPadding: {
        if (ScrollBar.horizontal
            && ScrollBar.horizontal.background
            && ScrollBar.horizontal.background.visible
        ) {
            return ScrollBar.horizontal.background.height
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
