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

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    color: Kirigami.Theme.backgroundColor

    Item {
        id: headerColor

        Kirigami.Theme.colorSet: Kirigami.Theme.Header
        Kirigami.Theme.inherit: false

        property color backgroundColor: Kirigami.Theme.backgroundColor
        onBackgroundColorChanged: {
            GuiAddons.WindowInsetsController.statusBarBackgroundColor = Kirigami.Theme.backgroundColor;
        }
    }

    QtObject {
        id: statusBarColor

        readonly property color windowColor: window.Kirigami.Theme.backgroundColor
        readonly property color footerColor: window.footer?.Kirigami.Theme.backgroundColor

        onWindowColorChanged: {
            if (!window.footer) {
                GuiAddons.WindowInsetsController.navigationBarBackgroundColor = Kirigami.Theme.backgroundColor;
            }
        }

        onFooterColorChanged: {
            if (window.footer) {
                GuiAddons.WindowInsetsController.navigationBarBackgroundColor = window.footer.Kirigami.Theme.backgroundColor;
            }
        }
    }
}
