import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami

T.MenuSeparator {
    id: control
    palette: Kirigami.Theme.palette

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentItem: Controls.ToolSeparator {
        orientation: Qt.Horizontal
    }
}
