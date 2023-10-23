/* SPDX-FileCopyrightText: 2023 Devin Lin <devin@kd.org>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick
import org.kde.kirigami as Kirigami

pragma Singleton

QtObject {

    // these are functions, not properties because we use Kirigami.Theme, which is context dependent
    function separatorColor() {
        switch (Kirigami.Theme.colorSet) {
            case Kirigami.Theme.Button:
                return separatorColorHelper(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.3);
            case Kirigami.Theme.Selection:
                return Kirigami.Theme.focusColor;
            default:
                return separatorColorHelper(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.2);
        }
    }

    function buttonSeparatorColor() {
        return separatorColorHelper(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.3);
    }

    function separatorColorHelper(bg, fg, baseRatio) {
        if (Kirigami.ColorUtils.brightnessForColor(bg) === Kirigami.ColorUtils.Light) {
            return Kirigami.ColorUtils.linearInterpolation(bg, fg, baseRatio);
        } else {
            return Kirigami.ColorUtils.linearInterpolation(bg, fg, baseRatio / 2);
        }
    }
}
