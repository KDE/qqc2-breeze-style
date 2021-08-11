/*
    SPDX-FileCopyrightText: 2021 Jonah Brüchert <jbb@kaidan.im>
    SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef UNITS_H
#define UNITS_H

#include <QObject>

#include <Kirigami2/Units>

#include <KConfigWatcher>

class Units : public Kirigami::Units
{
    Q_OBJECT

public:
    explicit Units(QObject *parent = nullptr);

    void updateAnimationSpeed();

private:
    KConfigWatcher::Ptr m_animationSpeedWatcher;
};

#endif
