/*
 * SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

//NOTE: For some reason, this version of IconLabelContent causes Kirigami Gallery to freeze when you open a section
Grid {
    id: root

    property alias control: root.parent
    property alias icon: contentIcon
    property alias label: contentLabel
    property bool reserveSpaceForIcon: false
    readonly property bool hasValidIconSize: control.icon.width && control.icon.height

    //BEGIN These exist for compatibility with Qt's IconLabel
    property alias text: contentLabel.text
    property alias font: contentLabel.font
    property alias color: contentLabel.color
    property int display: control.display
    property bool mirrored: control.mirrored
    property int alignment: {
        let halignment = 0
        if (
            (root.display === Controls.AbstractButton.TextBesideIcon
                && icon.visible && label.visible)
            || control.indicator//!(control instanceof Controls.Button)
        ) {
            halignment = Qt.AlignLeft
        } else {
            halignment = Qt.AlignHCenter
        }

        let valignment = 0
        if (
            (root.display === Controls.AbstractButton.TextUnderIcon
                && icon.visible && label.visible)
            //|| !(control instanceof Controls.Button)
        ) {
            valignment = Qt.AlignTop
        } else {
            valignment = Qt.AlignVCenter
        }
        return halignment | valignment
    }
    //END Qt IconLabel compatibility properties
    property int horizontalAlignment: root.alignment & Qt.AlignHorizontal_Mask
    property int verticalAlignment: root.alignment & Qt.AlignVertical_Mask

    property real horizontalPadding: padding
    property real verticalPadding: padding
    padding: 0
    leftPadding: {
        let lpad = horizontalPadding
        if (reserveSpaceForIcon && !icon.visible) {
            lpad += control.icon.width + root.spacing
        }
        if (control.indicator && control.indicator.width > 0) {
            lpad += control.indicator.width + root.spacing
        }
        return lpad
    }
    rightPadding: horizontalPadding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    spacing: control.spacing
    rows: root.display == Controls.AbstractButton.TextUnderIcon && icon.visible && label.visible ? 2 : 1
    columns: root.display == Controls.AbstractButton.TextBesideIcon && icon.visible && label.visible ? 2 : 1

    horizontalItemAlignment: root.horizontalAlignment
    verticalItemAlignment: root.verticalAlignment

    Kirigami.Icon {
        id: contentIcon
        implicitWidth: hasValidIconSize ? control.icon.width : Kirigami.Units.iconSizes.auto
        implicitHeight: hasValidIconSize ? control.icon.height : Kirigami.Units.iconSizes.auto
        visible: icon.valid && root.display !== Controls.AbstractButton.TextOnly
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-abstractbutton.html#icon.name-prop
        // If icon.name is not found, icon.source will be used instead.
        source: control.icon.name ?? control.icon.source
        color: control.icon.color
    }

    Item {
        implicitWidth: Math.ceil(contentLabel.implicitWidth)
        implicitHeight: Math.ceil(contentLabel.implicitHeight)
        Controls.Label {
            id: contentLabel
            anchors.fill: parent
            visible: text.length > 0 && root.display !== Controls.AbstractButton.IconOnly
            text: control.text
            font: control.font
            horizontalAlignment: root.horizontalAlignment
            verticalAlignment: root.verticalAlignment
            elide: Text.ElideRight
        }
    }
}
