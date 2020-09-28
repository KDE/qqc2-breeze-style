/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Window 2.2
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.14 as Kirigami

T.Label {
    id: control

    palette: Kirigami.Theme.palette
    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    font.capitalization: Kirigami.Theme.defaultFont.capitalization
    font.family: Kirigami.Theme.defaultFont.family
    font.italic: Kirigami.Theme.defaultFont.italic
    font.letterSpacing: Kirigami.Theme.defaultFont.letterSpacing
    font.pointSize: Kirigami.Theme.defaultFont.pointSize
    font.strikeout: Kirigami.Theme.defaultFont.strikeout
    font.underline: Kirigami.Theme.defaultFont.underline
    font.weight: Kirigami.Theme.defaultFont.weight
    font.wordSpacing: Kirigami.Theme.defaultFont.wordSpacing
    color: Kirigami.Theme.textColor
    linkColor: Kirigami.Theme.linkColor

//     opacity: enabled? 1 : 0.6

    Accessible.role: Accessible.StaticText
    Accessible.name: text
}
