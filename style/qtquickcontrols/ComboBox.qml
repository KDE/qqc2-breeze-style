import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami
import "impl"

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

//     leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    //rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: control.editable ? Kirigami.Theme.View : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    delegate: ItemDelegate {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        palette.text: control.palette.text
        palette.highlightedText: control.palette.highlightedText
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
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
    
    contentItem: MouseArea {
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
        T.TextField {
            id: textField
            padding: 0
            anchors {
                fill:parent
                leftMargin: control.leftPadding
                rightMargin: control.rightPadding
                topMargin: control.topPadding
                bottomMargin: control.bottomPadding
            }
            text: control.editable ? control.editText : control.displayText

            enabled: control.editable
            autoScroll: control.editable
            readOnly: control.down

            visible: typeof(control.editable) != "undefined" && control.editable
            inputMethodHints: control.inputMethodHints
            validator: control.validator

            // Work around Qt bug where NativeRendering breaks for non-integer scale factors
            // https://bugreports.qt.io/browse/QTBUG-67007
            renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
            color: control.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            selectionColor: Kirigami.Theme.highlightColor
            selectedTextColor: Kirigami.Theme.highlightedTextColor

            selectByMouse: !Kirigami.Settings.tabletMode
            cursorDelegate: Kirigami.Settings.tabletMode ? mobileCursor : null

            font: control.font
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            opacity: control.enabled ? 1 : 0.3

            onFocusChanged: {
                if (focus) {
                    Private.MobileTextActionsToolBar.control = textField;
                }
            }

            onTextChanged: Private.MobileTextActionsToolBar.shouldBeVisible = false;
            onPressed: Private.MobileTextActionsToolBar.shouldBeVisible = true;

            onPressAndHold: {
                if (!Kirigami.Settings.tabletMode) {
                    return;
                }
                forceActiveFocus();
                cursorPosition = positionAt(event.x, event.y);
                selectWord();
            }
        }
    }

    background: Kirigami.ShadowedRectangle {

        implicitWidth: 120
        implicitHeight: Kirigami.Units.mediumControlHeight
        
        //WTF: Sometimes hovered is true for all buttons in a section of a Kirigami app. It's hard to know when this will happen.
        visible: !control.flat || control.editable || control.down || control.checked || control.highlighted || control.visualFocus || control.hovered
        color: {
            if (control.down || control.checked ) {
                Kirigami.Theme.alternateBackgroundColor
            } else if (control.flat) {
                "transparent"
            } else {
                Kirigami.Theme.backgroundColor
            }
        }
        radius: Kirigami.Units.smallRadius
        border {
            color: (control.editable && control.activeFocus) || control.highlighted || control.visualFocus || control.hovered ?
                    Kirigami.Theme.focusColor :
                    Kirigami.ColorUtils.tintWithAlpha(mainBackground.color, Kirigami.Theme.textColor, 0.3)
            width: Kirigami.Units.smallBorder
        }
        shadow {
            color: Qt.rgba(0,0,0,0.2)
            size: control.editable || control.flat || control.down || !control.enabled ? 0 : 3
            yOffset: 1
        }

        FocusRect {
            baseRadius: mainBackground.radius
            visible: control.visualFocus || control.highlighted
        }

        BackgroundGradient {
            baseRadius: mainBackground.radius
            visible: !(control.editable || control.flat || control.down || control.hovered) && control.enabled
        }
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
                model: control.delegateModel
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
