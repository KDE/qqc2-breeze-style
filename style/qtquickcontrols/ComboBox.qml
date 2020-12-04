/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.mediumSpacing
    horizontalPadding: Kirigami.Units.mediumHorizontalPadding

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: control.editable ? Kirigami.Theme.View : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    spacing: Kirigami.Units.mediumSpacing

    delegate: Controls.MenuItem {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
        __reserveSpaceForIndicator: false
        __reserveSpaceForIcon: false
        __reserveSpaceForArrow: false
    }

    indicator: Kirigami.Icon {
        implicitHeight: Kirigami.Units.iconSizes.defaultSize
        implicitWidth: implicitHeight
        anchors {
            right: control.right
            rightMargin: control.rightPadding
            verticalCenter: control.verticalCenter
        }
        source: "arrow-down"
//         opacity: enabled ? 1 : 0.3
    }

    /*contentItem: T.TextField {
        padding: Kirigami.Units.controlPadding(control.implicitBackgroundHeight, control.implicitContentHeight)

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse

        font: control.font
        color: control.editable ? control.palette.text : control.palette.buttonText
        selectionColor: control.palette.highlight
        selectedTextColor: control.palette.highlightedText
        verticalAlignment: Text.AlignVCenter
    }*/

    contentItem: Controls.TextField {
        id: textField
        palette: control.palette
        padding: 0
        // Giving the TextField some extra click area on the sides
        leftPadding: control.leftPadding
        rightPadding: control.spacing
        topPadding: padding
        bottomPadding: padding
        // Intentionally using anchors here.
        // This allows us to control which parts of the combobox send mouse input to the TextField.
        anchors {
            fill: parent
            // The rightMargin isn't clickable, which allows the dropdown indicator to be clicked
            rightMargin: control.indicator ? indicator.width + control.rightPadding : 0
        }
        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator

        // Using palette instead of Kirigami.Theme.textColor because the latter
        // always uses the disabled palette when textField.enabled == false
        color: control.editable ? palette.text : palette.buttonText
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor

        selectByMouse: !Kirigami.Settings.tabletMode
        cursorDelegate: Kirigami.Settings.tabletMode ? mobileCursor : null
        
        Component {
            id: mobileCursor
            MobileCursor {
                target: control
            }
        }

        font: control.font
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        onTextChanged: MobileTextActionsToolBar.shouldBeVisible = false;
        onPressed: MobileTextActionsToolBar.shouldBeVisible = true;

        background: Item {}
    }
    /*MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        preventStealing: true
        property int indexUnderMouse: -1
        onWheel: {
            if (wheel.pixelDelta.y < 0 || wheel.angleDelta.y < 0) {
                control.incrementCurrentIndex();
            } else {
                control.decrementCurrentIndex();
            }
        }
        onPressed: {
            if (control.focusPolicy & Qt.ClickFocus) {
                control.forceActiveFocus();
            }

            indexUnderMouse = -1;
            listView.currentIndex = control.highlightedIndex
            control.down = true;
            control.pressed = true;
            control.popup.visible = !control.popup.visible;
        }
        onReleased: {
            if (!containsMouse) {
                control.down = false;
                control.pressed = false;
                control.popup.visible = false;
            }
            if (indexUnderMouse > -1) {
                controlWriter.writeProperty(indexUnderMouse);
                control.activated(indexUnderMouse);
            }
        }
        onCanceled: {
            control.down = false;
            control.pressed = false;
        }
        onPositionChanged: {
            var pos = listView.mapFromItem(this, mouse.x, mouse.y);
            indexUnderMouse = listView.indexAt(pos.x, pos.y);
            listView.currentIndex = indexUnderMouse;
        }

        Connections {
            target: popup
            onClosed: {
                control.down = false;
                control.pressed = false;
            }
        }
    }*/

    background: ComboBoxBackground {
        control: control
    }

    popup: Controls.Popup {
        padding: 0
        y: control.height - Kirigami.Units.smallBorder
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)

        contentItem: ScrollView {
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ListView {
                id: listView
                // this causes us to load at least one delegate
                // this is essential in guessing the contentHeight
                // which is needed to initially resize the popup
                cacheBuffer: 1
                clip: true
                implicitHeight: contentHeight
                model: control.delegateModel // Why isn't this in the ComboBox documentation?
                currentIndex: control.highlightedIndex
                highlightMoveDuration: -1
                highlightMoveVelocity: -1
                highlight: ListViewHighlight {}
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: Controls.ScrollBar {}
                //T.ScrollIndicator.vertical: ScrollIndicator { }
            }
        }

/*
        background: Rectangle {
            color: control.palette.window
            border.color: Kirigami.ColorUtils.linearInterpolation(mainBackground.color, Kirigami.Theme.textColor, 0.3)
        }*/
    }
}
