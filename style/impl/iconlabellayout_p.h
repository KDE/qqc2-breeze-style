/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
 */

#ifndef ICONLABELLAYOUT_P_H
#define ICONLABELLAYOUT_P_H

#include "iconlabellayout.h"

class IconLabelLayout::Private
{
    friend class IconLabelLayout;
public:
    Private(IconLabelLayout *qq) : q(qq) {}

    void setInitialIconItemProperties();
    bool createIconItem();
    bool destroyIconItem();
    bool updateIconItem();
    void syncIconItem();
    void updateOrSyncIconItem();

    void setInitialLabelItemProperties();
    bool createLabelItem();
    bool destroyLabelItem();
    bool updateLabelItem();
    void syncLabelItem();
    void updateOrSyncLabelItem();

    void updateImplicitSize();
    void layout();

    IconLabelLayout *q = nullptr;

    QPointer<QQmlComponent> iconComponent;
    QPointer<QQmlComponent> labelComponent;

    QPointer<QQuickItem> iconItem;
    QPointer<QQuickItem> labelItem;

    QVariantMap initialIconItemProperties = {
        {QStringLiteral("source"), QStringLiteral("")},
        {QStringLiteral("implicitWidth"), 0.0},
        {QStringLiteral("implicitHeight"), 0.0},
        {QStringLiteral("color"), QColor("transparent")},
        {QStringLiteral("cache"), true}
    };

    QVariantMap initialLabelItemProperties = {
        {QStringLiteral("text"), QString()},
        {QStringLiteral("font"), QFont()},
        {QStringLiteral("color"), QColor()},
        {QStringLiteral("horizontalAlignment"), Qt::AlignHCenter},
        {QStringLiteral("verticalAlignment"), Qt::AlignVCenter}
    };

    bool hasIcon = false;
    bool hasLabel = false;

    QQuickIcon icon = QQuickIcon();
    QString text = QStringLiteral("");
    QFont font = QFont();
    QColor color = QColor();

    qreal availableWidth = 0.0;
    qreal availableHeight = 0.0;

    qreal spacing = 0.0;
    qreal leftPadding = 0.0;
    qreal rightPadding = 0.0;
    qreal topPadding = 0.0;
    qreal bottomPadding = 0.0;

    bool mirrored = false;
    Qt::Alignment alignment = Qt::AlignCenter;
    Display display = Display::TextBesideIcon;

    QRectF iconRect = QRectF(0,0,0,0);
    QRectF labelRect = QRectF(0,0,0,0);
    qreal contentWidth = 0.0;
    qreal contentHeight = 0.0;

    bool firstLayoutCompleted = false;
    int layoutCount = 0;
};

#endif
