import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T

T.StackView {
    id: control

    popEnter: Transition {
        XAnimator { from: (control.mirrored ? -1 : 1) * -control.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
    }

    popExit: Transition {
        XAnimator { from: 0; to: (control.mirrored ? -1 : 1) * control.width; duration: 400; easing.type: Easing.OutCubic }
    }

    pushEnter: Transition {
        XAnimator { from: (control.mirrored ? -1 : 1) * control.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
    }

    pushExit: Transition {
        XAnimator { from: 0; to: (control.mirrored ? -1 : 1) * -control.width; duration: 400; easing.type: Easing.OutCubic }
    }

    replaceEnter: Transition {
        XAnimator { from: (control.mirrored ? -1 : 1) * control.width; to: 0; duration: 400; easing.type: Easing.OutCubic }
    }

    replaceExit: Transition {
        XAnimator { from: 0; to: (control.mirrored ? -1 : 1) * -control.width; duration: 400; easing.type: Easing.OutCubic }
    }
}
