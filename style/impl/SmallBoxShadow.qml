/* SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import org.kde.kirigami 2.19 as Kirigami

import "." as Impl

// Simple box shadow which is ideal for subtle shadows, as it is very performant.
Rectangle {
    id: root
    anchors.top: parent.top
    anchors.topMargin: 1
    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height
    z: -1
    color: Qt.rgba(0, 0, 0, 0.1)
}
