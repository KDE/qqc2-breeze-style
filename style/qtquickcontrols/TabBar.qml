//NOTE: replace this

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

import org.kde.breeze.impl as Impl

T.TabBar {
    id: control

    readonly property bool __isHeader: control.position === T.TabBar.Header
    readonly property bool __isFooter: control.position === T.TabBar.Footer

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: -1
    padding: 0

    // Add space for the separator above the footer
    topPadding: __isFooter && background && background.hasOwnProperty("separator") ?
        background.separator.height + verticalPadding : verticalPadding
    // Add space for the separator below the header
    bottomPadding: __isHeader && background && background.hasOwnProperty("separator") ?
        background.separator.height + verticalPadding : verticalPadding

    Kirigami.Theme.inherit: !__isHeader
    Kirigami.Theme.colorSet: Kirigami.Theme.Header

    contentItem: ListView {
        model: control.contentModel
        currentIndex: control.currentIndex

        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem
    }

    background: Impl.StandardRectangle {
        // Enough height for Buttons/ComboBoxes/TextFields with smallSpacing padding on top and bottom
        implicitHeight: Impl.Units.mediumControlHeight + (Kirigami.Units.smallSpacing * 2) + (separator.visible ? separator.height : 0)
        color: Kirigami.Theme.backgroundColor
        property Item separator: Kirigami.Separator {
            parent: background
            visible: control.__isHeader || control.__isFooter
            width: parent.width
            y: control.__isFooter ? 0 : parent.height - height
        }
    }
}
