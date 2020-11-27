/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

//NOTE: For some reason, Kirigami Gallery freezes when opening a section if I make an equivalent version of this with Grid instead of GridLayout
GridLayout {
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
    property real spacing: control.spacing
    property bool mirrored: control.mirrored

    property int alignment: {
        let halignment = 0
        if (
            (root.display === Controls.AbstractButton.TextBesideIcon
                && icon.visible && label.visible)
            || control.indicator//!(control instanceof Controls.Button)
        ) {
            halignment = Text.AlignLeft
        } else {
            halignment = Text.AlignHCenter
        }

        let valignment = 0
        if (
            (root.display === Controls.AbstractButton.TextUnderIcon
                && icon.visible && label.visible)
            //|| !(control instanceof Controls.Button)
        ) {
            valignment = Text.AlignTop
        } else {
            valignment = Text.AlignVCenter
        }
        return halignment | valignment
    }

    property real leftPadding: {
        let lpad = horizontalPadding
        /*
        // Not needed since Qt 5.15.2
        if (root.mirrored) {
            return lpad
        }
        */
        if (reserveSpaceForIcon && !icon.visible) {
            lpad += control.icon.width + root.spacing
        }
        if (control.indicator && control.indicator.width > 0) {
            lpad += control.indicator.width + root.spacing
        }
        return lpad
    }
    property real rightPadding: {
        let rpad = horizontalPadding
        /*
        // Not needed since Qt 5.15.2
        if (!root.mirrored) {
            return rpad
        }
        if (reserveSpaceForIcon && !icon.visible) {
            rpad += control.icon.width + root.spacing
        }
        */
        if (control.arrow && control.arrow.width > 0) {
            rpad += control.arrow.width// + root.spacing // NOTE: It just looked a bit better without the spacing
        }
        return rpad
    }
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    //END Qt IconLabel properties
    property real padding: 0
    property real horizontalPadding: padding
    property real verticalPadding: padding

    property bool horizontal: root.flow === GridLayout.LeftToRight
    property bool vertical: root.flow === GridLayout.TopToBottom

    flow: root.display == Controls.AbstractButton.TextUnderIcon ? GridLayout.TopToBottom : GridLayout.LeftToRight
    rowSpacing: root.spacing
    columnSpacing: root.spacing

    LayoutMirroring.enabled: root.mirrored

    baselineOffset: height - bottomPadding

    Kirigami.Icon {
        id: contentIcon
        Layout.alignment: root.alignment
        Layout.leftMargin: root.leftPadding
        Layout.rightMargin: (!label.visible && !(root.children.length > 2 && root.children[2].visible)) && root.horizontal ? root.rightPadding : 0
        Layout.topMargin: root.topPadding
        Layout.bottomMargin: (!label.visible && !(root.children.length > 2 && root.children[2].visible)) && root.vertical ? root.bottomPadding : 0
        Layout.preferredWidth: hasValidIconSize ? control.icon.width : Kirigami.Units.iconSizes.auto
        Layout.preferredHeight: hasValidIconSize ? control.icon.height : Kirigami.Units.iconSizes.auto
        visible: icon.valid && root.display !== Controls.AbstractButton.TextOnly
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-abstractbutton.html#icon.name-prop
        // If icon.name is not found, icon.source will be automatically used instead.
        source: control.icon.name
        color: control.icon.color
    }

    Controls.Label {
        id: contentLabel
        Layout.alignment: root.alignment
        Layout.leftMargin: icon.visible && root.horizontal ? 0 : root.leftPadding
        Layout.rightMargin: (root.children.length > 2 && root.children[2].visible) && root.horizontal ? 0 : root.rightPadding
        Layout.topMargin: icon.visible && root.vertical ? 0 : root.topPadding
        Layout.bottomMargin: (root.children.length > 2 && root.children[2].visible) && root.vertical ? 0 : root.bottomPadding
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: text.length > 0 && root.display !== Controls.AbstractButton.IconOnly
        text: control.text
        font: control.font
        // QQuickText::HAlignment and QQuickText::VAlignment just use aliases to a subset of Qt::Alignment
        horizontalAlignment: root.alignment & (Text.AlignLeft | Text.AlignRight | Text.AlignHCenter | Text.Justify)
        verticalAlignment: root.alignment & (Text.AlignTop | Text.AlignBottom | Text.AlignVCenter)
        elide: Text.ElideRight
    }
}
