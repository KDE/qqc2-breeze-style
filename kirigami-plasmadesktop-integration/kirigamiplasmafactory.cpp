/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "kirigamiplasmafactory.h"
#include "plasmadesktoptheme.h"
#include "units.h"

KirigamiPlasmaFactory::KirigamiPlasmaFactory(QObject *parent)
    : Kirigami::Platform::PlatformPluginFactory(parent)
{
}

KirigamiPlasmaFactory::~KirigamiPlasmaFactory() = default;

Kirigami::Platform::PlatformTheme *KirigamiPlasmaFactory::createPlatformTheme(QObject *parent)
{
    Q_ASSERT(parent);
    return new PlasmaDesktopTheme(parent);
}

Kirigami::Platform::Units *KirigamiPlasmaFactory::createUnits(QObject *parent)
{
    Q_ASSERT(parent);
    return new Units(parent);
}

#include "moc_kirigamiplasmafactory.cpp"
