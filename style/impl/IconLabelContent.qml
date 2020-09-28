/*
 * SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

GridLayout {
    id: root

    property alias control: root.parent
    property alias labelText: contentLabel.text
    property real leftPadding: reserveSpaceForIcon && !icon.visible ? control.icon.width + control.spacing : 0
    property real rightPadding: 0
    property alias icon: contentIcon
    property alias label: contentLabel
    property bool reserveSpaceForIcon: false
    readonly property bool validIconSize: control.icon.width && control.icon.height

    columns: control.display == Controls.AbstractButton.TextBesideIcon ? 2 : 1
    rowSpacing: control.spacing
    columnSpacing: control.spacing

    Kirigami.Icon {
        id: contentIcon
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        Layout.leftMargin: root.leftPadding
        Layout.rightMargin: !label.visible ?
            root.rightPadding : 0
        Layout.preferredWidth: validIconSize ? control.icon.width : Kirigami.Units.iconSizes.defaultSize
        Layout.preferredHeight: validIconSize ? control.icon.height : Kirigami.Units.iconSizes.defaultSize
        visible: icon.valid && control.display !== Controls.AbstractButton.TextOnly
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-abstractbutton.html#icon.name-prop
        // If the icon is not found, icon.source will be used instead.
        source: control.icon.name
        color: control.icon.color
    }

    Controls.Label {
        id: contentLabel
        leftPadding: !icon.visible ?
            root.leftPadding : 0
        rightPadding: root.rightPadding
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: control.icon.width
        Layout.minimumHeight: control.icon.height
        visible: text.length > 0 && control.display !== Controls.AbstractButton.IconOnly
        font: control.font
        color: Kirigami.Theme.textColor
        horizontalAlignment: control.display !== Controls.AbstractButton.TextUnderIcon && icon.visible ? Text.AlignLeft : Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
