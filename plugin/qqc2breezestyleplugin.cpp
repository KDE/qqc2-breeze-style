/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "qqc2breezestyleplugin.h"

#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickItem>


void QQC2BreezeStylePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("org.kde.breeze"));

    qmlProtectModule(uri, 2);
}

#include "moc_qqc2breezestyleplugin.cpp"

