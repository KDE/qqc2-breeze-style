import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami
import "private"

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

//     padding: 8
//     leftPadding: padding + 4

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    color: Kirigami.Theme.textColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    placeholderTextColor: Kirigami.Theme.disabledTextColor
    verticalAlignment: TextInput.AlignVCenter

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 32
        radius: 3
        color: Kirigami.Theme.backgroundColor
        border {
            width: 1
            color: control.highlighted || control.activeFocus || control.hovered ?
                    Kirigami.Theme.highlightColor :
                    Color.blend(background.color, Kirigami.Theme.textColor, 0.3)
        }

        FocusRect {
            // control.visualFocus seems to not work
            visible: control.activeFocus && (control.focusReason == Qt.TabFocusReason || control.focusReason == Qt.BacktabFocusReason)
            baseRadius: background.radius
        }
    }
}
