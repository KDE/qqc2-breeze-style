// NOTE: checkthis
/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.14 as Kirigami
import "impl" as Impl

T.TextField {
    id: control

    property bool visualFocus: control.activeFocus && (
        control.focusReason == Qt.TabFocusReason ||
        control.focusReason == Qt.BacktabFocusReason ||
        control.focusReason == Qt.ShortcutFocusReason
    )

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.ceil(Math.max(contentWidth, placeholder.implicitWidth)) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: Impl.Units.mediumSpacing
    leftPadding: Impl.Units.mediumHorizontalPadding
    rightPadding: Impl.Units.mediumHorizontalPadding

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: !background || !background.visible

    color: Kirigami.Theme.textColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    placeholderTextColor: Kirigami.Theme.disabledTextColor
    verticalAlignment: TextInput.AlignVCenter
    horizontalAlignment: TextInput.AlignLeft

    selectByMouse: true
    mouseSelectionMode: Kirigami.Settings.tabletMode ?
        TextInput.SelectWords : TextInput.SelectCharacters

    cursorDelegate: Loader {
        visible: control.activeFocus && !control.readOnly && control.selectionStart === control.selectionEnd
        active: visible
        sourceComponent: Impl.CursorDelegate { target: control }
    }

    Controls.Label {
        id: placeholder
        anchors {
            fill: parent
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
            topMargin: control.topPadding
            bottomMargin: control.bottomPadding
        }

        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        horizontalAlignment: control.horizontalAlignment
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: Impl.TextEditBackground {
        control: control
        implicitWidth: 200
        visualFocus: control.visualFocus
    }

    Impl.CursorHandle {
        id: selectionStartHandle
        target: control
    }

    Impl.CursorHandle {
        id: selectionEndHandle
        target: control
        isSelectionEnd: true
    }

    MobileTextActionsToolBar {
        id: mobileTextActionsToolBar
        target: control
    }

    onActiveFocusChanged: {
        if (!activeFocus) {
            mobileTextActionsToolBar.visible = false
        } else if (Kirigami.Settings.tabletMode) {
            mobileTextActionsToolBar.visible = true
        }
    }

    onSelectedTextChanged: {
        if (Kirigami.Settings.tabletMode && selectedText.length > 0) {
            mobileTextActionsToolBar.item.open()
        }
    }

    onPressAndHold: {
        if (Kirigami.Settings.tabletMode) {
            forceActiveFocus();
            cursorPosition = positionAt(event.x, event.y);
            selectWord();
            mobileTextActionsToolBar.item.open()
        }
    }
}
