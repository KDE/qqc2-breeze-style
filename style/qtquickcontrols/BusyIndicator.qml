import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

T.BusyIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 6

    contentItem: BusyIndicatorImpl {
        implicitWidth: 48
        implicitHeight: 48

        pen: control.palette.dark
        fill: control.palette.dark

        running: control.running
        opacity: control.running ? 1 : 0
        Behavior on opacity { OpacityAnimator { duration: 250 } }
    }
}
