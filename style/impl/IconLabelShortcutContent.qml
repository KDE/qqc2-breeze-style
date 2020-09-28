/*
 * SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

Controls.Control {
    id: root

    property alias control: root.parent

    property string labelText: ""

    contentItem: RowLayout {

        columns: control.display == Controls.AbstractButton.TextBesideIcon ? 2 : 1
        rowSpacing: control.spacing
        columnSpacing: rowSpacing

        Kirigami.Icon {
            id: contentIcon
            Layout.preferredWidth: control.icon.width
            Layout.preferredHeight: control.icon.height
            visible: contentIcon.valid && control.display !== Controls.AbstractButton.TextOnly
            // https://doc.qt.io/qt-5/qml-qtquick-controls2-abstractbutton.html#icon.name-prop
            // If the icon is not found, icon.source will be used instead.
            source: control.icon.name
            color: control.icon.color
        }

        Controls.Label {
            id: contentLabel
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: control.icon.width
            Layout.minimumHeight: control.icon.height
            visible: text.length > 0 && control.display !== Controls.AbstractButton.IconOnly
            text: labelText
            font: control.font
            color: Kirigami.Theme.textColor
            horizontalAlignment: control.display !== Controls.AbstractButton.TextUnderIcon && contentIcon.visible ? Text.AlignLeft : Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Controls.Label {
            id: shortcut
            Layout.alignment: Qt.AlignVCenter
            visible: control.action && control.action.hasOwnProperty("shortcut") && control.action.shortcut !== undefined

            Shortcut {
                id: itemShortcut
                sequence: (parent.visible && control.action !== null) ? control.action.shortcut : ""
            }

            text: visible ? itemShortcut.nativeText : ""
            font: control.font
            color: contentLabel.color
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }
}
