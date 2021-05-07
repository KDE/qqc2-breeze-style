/*
 * SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later OR LicenseRef-KDE-Accepted-LGPL OR LicenseRef-KFQF-Accepted-GPL
 */

#include "qqc2breezestyleplugin.h"
#include "impl/breezedial.h"
#include "impl/iconlabellayout.h"
#include "impl/kcolorutilssingleton.h"
#include "impl/paintedsymbolitem.h"

#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlFile>
#include <QQuickWindow>

QQC2BreezeStylePlugin::QQC2BreezeStylePlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
}

QQC2BreezeStylePlugin::~QQC2BreezeStylePlugin()
{
}

QString QQC2BreezeStylePlugin::name() const
{
    return QStringLiteral("org.kde.breeze");
}

void QQC2BreezeStylePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == name());

    // BEGIN org.kde.breeze
    qmlRegisterModule(uri, 1, 0);
    qmlRegisterType<PaintedSymbolItem>(uri, 1, 0, "PaintedSymbol");
    qmlRegisterType<IconLabelLayout>(uri, 1, 0, "IconLabelLayout");
    qmlRegisterType<BreezeDial>(uri, 1, 0, "BreezeDial");
    // KColorUtilsSingleton only has invocable functions.
    // Would this be better off being a SingletonInstance?
    qmlRegisterSingletonType<KColorUtilsSingleton>(uri, 1, 0, "KColorUtils", [](QQmlEngine *, QJSEngine *) -> QObject * {
        return new KColorUtilsSingleton;
    });
    // END

    // Prevent additional types from being added.
    qmlProtectModule(uri, 1);
}

#include "moc_qqc2breezestyleplugin.cpp"
