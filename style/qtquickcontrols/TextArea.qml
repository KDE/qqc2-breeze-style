// NOTE: check this
/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.breeze.impl as Impl

T.TextArea {
    id: control

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + topPadding + bottomPadding)
    property bool visualFocus: control.activeFocus && (
        control.focusReason == Qt.TabFocusReason ||
        control.focusReason == Qt.BacktabFocusReason ||
        control.focusReason == Qt.ShortcutFocusReason
    )


    padding: Kirigami.Units.mediumSpacing
    property real horizontalPadding: Impl.Units.mediumHorizontalPadding
    property real verticalPadding: padding
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: background == null

    color: Kirigami.Theme.textColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    placeholderTextColor: Kirigami.Theme.disabledTextColor

    selectByMouse: true
    mouseSelectionMode: Kirigami.Settings.tabletMode ?
        TextEdit.SelectWords : TextEdit.SelectCharacters

    cursorDelegate: Impl.CursorDelegate {
        visible: control.activeFocus && !control.readOnly && control.selectionStart === control.selectionEnd
        target: control
    }

    Label {
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

    background:Impl.TextEditBackground {
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
        if (Kirigami.Settings.tabletMode && selectByMouse) {
            forceActiveFocus();
            cursorPosition = positionAt(event.x, event.y);
            selectWord();
            mobileTextActionsToolBar.item.open()
        }
    }
}
