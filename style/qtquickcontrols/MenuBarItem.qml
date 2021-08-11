// NOTE: check this
/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl" as Impl

T.MenuBarItem {
    id: controlRoot

    palette: Kirigami.Theme.palette
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    baselineOffset: contentItem.y + contentItem.baselineOffset

    Layout.fillWidth: true
    leftPadding: Impl.Units.largeSpacing
    rightPadding: Impl.Units.largeSpacing
    topPadding: Impl.Units.smallSpacing
    bottomPadding: Impl.Units.smallSpacing
    hoverEnabled: true

    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.MenuItem
    Kirigami.MnemonicData.label: controlRoot.text

    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: controlRoot.clicked();
    }

    contentItem: Controls.Label {
        text: controlRoot.Kirigami.MnemonicData.richTextLabel
        font: controlRoot.font
        color: controlRoot.hovered && !controlRoot.pressed ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Item {
        anchors.fill: parent
        implicitWidth: Impl.Units.gridUnit * 8

        Rectangle {
            anchors.fill: parent
            color: Kirigami.Theme.highlightColor
            opacity: controlRoot.down || controlRoot.highlighted  ? 0.7 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }
}
