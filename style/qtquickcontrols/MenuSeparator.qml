/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

T.MenuSeparator {
    id: control
    // palette: Kirigami.Theme.palette

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    hoverEnabled: false
    focusPolicy: Qt.NoFocus

    topPadding: Kirigami.Units.smallSpacing / 2
    bottomPadding: Kirigami.Units.smallSpacing / 2

    contentItem: Kirigami.Separator {
        implicitWidth: Kirigami.Units.gridUnit * 8
        implicitHeight: 1
    }
}
