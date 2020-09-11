import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami

T.ApplicationWindow {
    id: window
    palette: Kirigami.Theme.palette
    color: Kirigami.Theme.background

    overlay.modal: Rectangle {
        color: Color.transparent(window.palette.shadow, 0.5)
    }

    overlay.modeless: Rectangle {
        color: Color.transparent(window.palette.shadow, 0.12)
    }
}
