/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

T.ApplicationWindow {
    id: window
    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    color: Kirigami.Theme.backgroundColor
}
