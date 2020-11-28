// NOTE: replace this
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

T.ScrollBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: control.interactive ? Kirigami.Units.mediumSpacing : Kirigami.Units.verySmallSpacing
    leftPadding: horizontalPadding + separator.thickness

    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: horizontal ? height / width : width / height

    policy: Kirigami.Settings.isMobile ? ScrollBar.AsNeeded : T.ScrollBar.AlwaysOn

    contentItem: Rectangle {
        implicitWidth: Kirigami.Units.grooveHeight
        implicitHeight: implicitWidth

        radius: width / 2
        color: control.pressed ? Kirigami.Theme.highlightColor : Kirigami.Theme.separatorColor
        opacity: Kirigami.Settings.isMobile ? 0 : 1

        states: State {
            name: "active"
            when: control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
            PropertyChanges {
                target: control.contentItem
                opacity: Kirigami.Settings.isMobile ? 0.75 : 1
            }
        }

        transitions: Transition {
            from: "active"
            SequentialAnimation {
                PauseAnimation { duration: 450 }
                OpacityAnimator {
                    //target: control.contentItem
                    duration: Kirigami.Units.longDuration
//                     property: "opacity"
                    to: 0.0
                }
            }
        }
    }

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        Kirigami.Separator {
            id: separator
            property int thickness: Math.min(width, height)
            anchors {
                left: parent.left
                right: control.horizontal ? parent.right : undefined
                top: parent.top
                bottom: control.vertical ? parent.bottom : undefined
            }
        }
    }
    
}
