/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */
import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import org.kde.breeze 1.0
import "impl"

T.ToolButton {
    id: control

    // HACK: Compatibility with qqc2-desktop-style hack for showing arrows when buttons open menus
    // This one is at the level of `control` to make it more reliably accessible to the indicator.
    // Unlike qqc2-desktop-style, the arrow is in the indicator property instead of the background.
    property bool __showMenuArrow: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    flat: true

    Kirigami.Theme.colorSet: /*control.highlighted ? Kirigami.Theme.Selection :*/ Kirigami.Theme.Button
    Kirigami.Theme.inherit: false//control.flat && !control.down && !control.checked
    // Absolutely terrible HACK:
    // For some reason, ActionToolBar overrides the colorSet and inherit attached properties
    Component.onCompleted: {
        //console.log("colorSet: " + Kirigami.Theme.colorSet)
        //console.log("inherit: " + Kirigami.Theme.inherit)
        Kirigami.Theme.colorSet = Kirigami.Theme.Button/*Qt.binding(() => control.highlighted ? Kirigami.Theme.Selection : Kirigami.Theme.Button)*/
        Kirigami.Theme.inherit = false//Qt.binding(() => control.flat && !(control.down || control.checked))
    }

    padding: Kirigami.Units.mediumSpacing
    leftPadding: {
        if ((!contentItem.hasIcon && contentItem.textBesideIcon) // False if contentItem has been replaced
            || display == T.AbstractButton.TextOnly
            || display == T.AbstractButton.TextUnderIcon) {
            return Kirigami.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }
    rightPadding: {
        if (contentItem.hasLabel && display != T.AbstractButton.IconOnly) { // False if contentItem has been replaced
            return Kirigami.Units.mediumHorizontalPadding
        } else {
            return control.horizontalPadding
        }
    }

    spacing: Kirigami.Units.mediumSpacing

    icon.width: Kirigami.Units.iconSizes.auto
    icon.height: Kirigami.Units.iconSizes.auto

    Kirigami.MnemonicData.enabled: control.enabled && control.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: control.display !== T.Button.IconOnly ? control.text : ""
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(control.text))
        sequence: control.Kirigami.MnemonicData.sequence
        onActivated: control.clicked()
    }

    contentItem: IconLabelContent {
        control: control
        text: control.Kirigami.MnemonicData.richTextLabel
    }

    // Using a Loader here reduces the RAM usage
    indicator: Loader {
        property alias iconHeight: control.icon.height
        property alias iconWidth: control.icon.width
        anchors {
            right: control.right
            rightMargin: control.rightPadding
            verticalCenter: control.verticalCenter
        }
        visible: control.__showMenuArrow
        active: visible
        sourceComponent: Component {
            Kirigami.Icon {
                anchors.centerIn: parent
                implicitHeight: iconHeight
                implicitWidth: iconWidth
                source: "arrow-down"
            }
        }
    }

    background: ButtonBackground {
        // HACK: Compatibility with qqc2-desktop-style hack for showing arrows when buttons open menus
        // This one is in the background because that's what Kirigami expects
        property alias showMenuArrow: control.__showMenuArrow
        control: control
    }
}
