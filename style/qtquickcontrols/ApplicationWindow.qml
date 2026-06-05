/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQml
import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.guiaddons as GuiAddons

T.ApplicationWindow {
    id: window

    color: palette.window

    Item {
        id: headerColor

        Kirigami.Theme.colorSet: Kirigami.Theme.Header
        Kirigami.Theme.inherit: false

        Binding {
            target: GuiAddons.WindowInsetsController
            property: "statusBarBackgroundColor"
            value: window.palette.window
        }
    }

    Binding {
        target: GuiAddons.WindowInsetsController
        property: "navigationBarBackgroundColor"
        value: window.footer ? window.footer.palette.window : window.palette.window
    }
}
