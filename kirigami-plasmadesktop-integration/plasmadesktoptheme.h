/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
    SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef KIRIGAMIPLASMATHEME_H
#define KIRIGAMIPLASMATHEME_H

#include <Kirigami/Platform/PlatformTheme>
#include <QColor>
#include <QIcon>
#include <QObject>
#include <QPointer>
#include <QQuickItem>

class PlasmaDesktopTheme;
class KIconLoader;
class StyleSingleton;

class PlasmaDesktopTheme : public Kirigami::Platform::PlatformTheme
{
    Q_OBJECT

    // Breeze QQC2 style colors
    Q_PROPERTY(QColor separatorColor READ separatorColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonSeparatorColor READ buttonSeparatorColor NOTIFY colorsChanged)

    // Needed to deal with ShadowedRectangle
    Q_PROPERTY(bool lowPowerHardware READ lowPowerHardware CONSTANT FINAL)

public:
    explicit PlasmaDesktopTheme(QObject *parent = nullptr);
    ~PlasmaDesktopTheme() override;

    Q_INVOKABLE QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

    void syncWindow();
    void syncColors();

    // Breeze QQC2 style colors
    QColor separatorColor() const;
    QColor buttonSeparatorColor() const;

    bool lowPowerHardware() const;

protected:
    bool event(QEvent *event) override;

private:
    friend class StyleSingleton;
    QPointer<QWindow> m_window;

    // Breeze QQC2 style colors
    QColor m_separatorColor;
    QColor m_buttonSeparatorColor;

    // Needed to deal with ShadowedRectangle
    bool m_lowPowerHardware = false;
};

#endif // KIRIGAMIPLASMATHEME_H
