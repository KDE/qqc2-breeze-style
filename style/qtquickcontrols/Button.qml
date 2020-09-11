import QtQuick 2.12
import QtQuick.Controls 2.12 as Controls
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import org.kde.kirigami 2.14 as Kirigami
import "private"

T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    flat: false
    
    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: flat
    
    hoverEnabled: true

    padding: Math.round(Math.abs(implicitBackgroundHeight - implicitContentHeight)/2)
    spacing: 4

    readonly property int defaultIconSize: Kirigami.Units.fontMetrics.roundedIconSize(Kirigami.Units.gridUnit)

    icon.width: defaultIconSize
    icon.height: defaultIconSize

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
        labelText: control.Kirigami.MnemonicData.richTextLabel
    }

    background: ButtonBackground {
        control: control
    }
}
