import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

T.ToolBar {
    id: control
    palette: Kirigami.Theme.palette

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    horizontalPadding: 4

    background: Rectangle {
        implicitHeight: 40
        color: Kirigami.Theme.backgroundColor
        Controls.ToolSeparator {
            orientation: Qt.Horizontal
            readonly property bool isHeader: control.position == T.ToolBar.Header
            readonly property bool isFooter: control.position == T.ToolBar.Footer
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
