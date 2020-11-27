/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.15
import "../../" as Base
import org.kde.kirigami 2.14 as Kirigami
Base.Separator {
    id: root
    color: weight == Base.Separator.Weight.Light ? Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.separatorColor,  0.4 /*maybe 0.33*/) : Kirigami.Theme.separatorColor
}

