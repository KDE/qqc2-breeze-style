/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#ifndef KIRIGAMIPLASMATHEME_H
#define KIRIGAMIPLASMATHEME_H

#include <Kirigami2/PlatformTheme>
#include <QObject>
#include <QQuickItem>
#include <QColor>
#include <QPointer>
#include <QIcon>

class PlasmaDesktopTheme;
class KIconLoader;

class PlasmaDesktopTheme : public Kirigami::PlatformTheme
{
    Q_OBJECT

    // colors
//     Q_PROPERTY(QColor buttonTextColor READ buttonTextColor NOTIFY colorsChanged)

public:
    explicit PlasmaDesktopTheme(QObject *parent = nullptr);
    ~PlasmaDesktopTheme() override;

    Q_INVOKABLE QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

    void syncColors();

Q_SIGNALS:
    void colorsChanged();

protected Q_SLOTS:
    void configurationChanged();

private:
    QPointer<QQuickItem> m_parentItem;
    QPointer<QWindow> m_window;
};


#endif // KIRIGAMIPLASMATHEME_H
