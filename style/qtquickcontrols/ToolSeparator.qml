import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Controls.impl 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami

T.ToolSeparator {
    id: control
    palette: Kirigami.Theme.palette

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentItem: Rectangle {
        implicitWidth: vertical ? 1 : 32
        implicitHeight: vertical ? 32 : 1
        color: Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2);
    }
}
