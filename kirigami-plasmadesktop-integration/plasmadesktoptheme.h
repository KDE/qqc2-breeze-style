/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
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
    Q_PROPERTY(QColor buttonTextColor READ buttonTextColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonBackgroundColor READ buttonBackgroundColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonHoverColor READ buttonHoverColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonFocusColor READ buttonFocusColor NOTIFY colorsChanged)

    Q_PROPERTY(QColor viewTextColor READ viewTextColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor viewBackgroundColor READ viewBackgroundColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor viewHoverColor READ viewHoverColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor viewFocusColor READ viewFocusColor NOTIFY colorsChanged)

    // Breeze QQC2 style colors
    Q_PROPERTY(QColor separatorColor READ separatorColor NOTIFY colorsChanged)
    Q_PROPERTY(QColor buttonSeparatorColor READ buttonSeparatorColor NOTIFY colorsChanged)

    // Needed to deal with ShadowedRectangle
    Q_PROPERTY(bool lowPowerHardware MEMBER m_lowPowerHardware CONSTANT)

public:
    explicit PlasmaDesktopTheme(QObject *parent = nullptr);
    ~PlasmaDesktopTheme() override;

    Q_INVOKABLE QIcon iconFromTheme(const QString &name, const QColor &customColor = Qt::transparent) override;

    void syncColors();

    QColor buttonTextColor() const;
    QColor buttonBackgroundColor() const;
    QColor buttonHoverColor() const;
    QColor buttonFocusColor() const;

    QColor viewTextColor() const;
    QColor viewBackgroundColor() const;
    QColor viewHoverColor() const;
    QColor viewFocusColor() const;

    // Breeze QQC2 style colors
    QColor separatorColor() const;
    QColor buttonSeparatorColor() const;

Q_SIGNALS:
    void colorsChanged();

protected Q_SLOTS:
    void configurationChanged();

private:
    QPointer<QQuickItem> m_parentItem;
    QPointer<QWindow> m_window;

    //legacy colors
    QColor m_buttonTextColor;
    QColor m_buttonBackgroundColor;
    QColor m_buttonHoverColor;
    QColor m_buttonFocusColor;
    QColor m_viewTextColor;
    QColor m_viewBackgroundColor;
    QColor m_viewHoverColor;
    QColor m_viewFocusColor;

    // Breeze QQC2 style colors
    QColor m_separatorColor;
    QColor m_buttonSeparatorColor;

    // Needed to deal with ShadowedRectangle
    bool m_lowPowerHardware = false;

    bool m_mobile = true;
    bool m_hasTouchScreen = true;
};


#endif // KIRIGAMIPLASMATHEME_H
