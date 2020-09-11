import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami

T.ToolBar {
    id: control
    palette: Kirigami.Theme.palette

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    
//     padding: 4

    background: Rectangle {
        implicitHeight: 40
        color: Kirigami.Theme.backgroundColor
        Controls.ToolSeparator {
            orientation: Qt.Horizontal
            readonly property bool isHeader: control.position == T.ToolBar.Header || (control.parent.header && control.parent.header == control)
            readonly property bool isFooter: control.position == T.ToolBar.Footer || (control.parent.footer && control.parent.footer == control)
            visible: isHeader || isFooter
            anchors {
                left: parent.left
                right: parent.right
                top: isFooter ? parent.top : undefined
                bottom: isHeader ? parent.bottom : undefined
            }
        }
    }
}
