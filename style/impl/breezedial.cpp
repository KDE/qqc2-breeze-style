/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

#include "breezedial.h"
#include <QGuiApplication>
#include <QPainter>

class BreezeDialPrivate
{
    Q_DECLARE_PUBLIC(BreezeDial)
    Q_DISABLE_COPY(BreezeDialPrivate)
public:
    BreezeDialPrivate(BreezeDial *qq)
        : q_ptr(qq)
    {
    }
    BreezeDial *const q_ptr;

    QFontMetricsF fontMetrics = QFontMetricsF(QGuiApplication::font());

    QColor backgroundColor;
    QColor backgroundBorderColor;
    QColor fillColor;
    QColor fillBorderColor;
    qreal angle = -140.0; // Range of QQuickDial::angle() is -140 to 140
    qreal grooveThickness = 0;
    bool notchesVisible = false;
};

BreezeDial::BreezeDial(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , d_ptr(new BreezeDialPrivate(this))
{
    Q_D(BreezeDial);
    connect(qGuiApp, &QGuiApplication::fontChanged, this, [this, d]() {
        d->fontMetrics = QFontMetricsF(QGuiApplication::font());
        update();
    });
}

BreezeDial::~BreezeDial() noexcept
{
}

void BreezeDial::paint(QPainter *painter)
{
    Q_D(BreezeDial);
    if (width() <= 0 || height() <= 0 || d->grooveThickness <= 0)
        return;

    QRectF paintRect;
    paintRect.setWidth(qMin(boundingRect().width() - d->grooveThickness, boundingRect().height() - d->grooveThickness));
    paintRect.setHeight(paintRect.width());
    paintRect.moveCenter(boundingRect().center());

    QPen backgroundBorderPen(d->backgroundBorderColor, d->grooveThickness, Qt::SolidLine, Qt::RoundCap);
    QPen backgroundPen(d->backgroundColor, d->grooveThickness - 2, Qt::SolidLine, Qt::RoundCap);
    QPen fillBorderPen(d->fillBorderColor, d->grooveThickness, Qt::SolidLine, Qt::RoundCap);
    QPen fillPen(d->fillColor, d->grooveThickness - 2, Qt::SolidLine, Qt::RoundCap);

    const qreal startAngle = -130 * 16;
    const qreal backgroundSpanAngle = -280 * 16;
    const qreal fillSpanAngle = (-d->angle - 140) * 16;

    painter->setRenderHint(QPainter::Antialiasing);
    painter->setPen(backgroundBorderPen);
    painter->drawArc(paintRect, startAngle, backgroundSpanAngle);
    painter->setPen(backgroundPen);
    painter->drawArc(paintRect, startAngle, backgroundSpanAngle);
    painter->setPen(fillBorderPen);
    painter->drawArc(paintRect, startAngle, fillSpanAngle);
    painter->setPen(fillPen);
    painter->drawArc(paintRect, startAngle, fillSpanAngle);
}

QColor BreezeDial::backgroundBorderColor() const
{
    Q_D(const BreezeDial);
    return d->backgroundBorderColor;
}

void BreezeDial::setBackgroundBorderColor(const QColor &color)
{
    Q_D(BreezeDial);
    if (d->backgroundBorderColor == color)
        return;

    d->backgroundBorderColor = color;
    update();
    Q_EMIT backgroundBorderColorChanged();
}

QColor BreezeDial::backgroundColor() const
{
    Q_D(const BreezeDial);
    return d->backgroundColor;
}

void BreezeDial::setBackgroundColor(const QColor &color)
{
    Q_D(BreezeDial);
    if (d->backgroundColor == color)
        return;

    d->backgroundColor = color;
    update();
    Q_EMIT backgroundColorChanged();
}

QColor BreezeDial::fillBorderColor() const
{
    Q_D(const BreezeDial);
    return d->fillBorderColor;
}

void BreezeDial::setFillBorderColor(const QColor &color)
{
    Q_D(BreezeDial);
    if (d->fillBorderColor == color)
        return;

    d->fillBorderColor = color;
    update();
    Q_EMIT fillBorderColorChanged();
}

QColor BreezeDial::fillColor() const
{
    Q_D(const BreezeDial);
    return d->fillColor;
}

void BreezeDial::setFillColor(const QColor &color)
{
    Q_D(BreezeDial);
    if (d->fillColor == color)
        return;

    d->fillColor = color;
    update();
    Q_EMIT fillColorChanged();
}

qreal BreezeDial::angle() const
{
    Q_D(const BreezeDial);
    return d->angle;
}

void BreezeDial::setAngle(const qreal angle)
{
    Q_D(BreezeDial);
    if (d->angle == angle)
        return;

    d->angle = angle;
    update();
    Q_EMIT angleChanged();
}

qreal BreezeDial::grooveThickness() const
{
    Q_D(const BreezeDial);
    return d->grooveThickness;
}

void BreezeDial::setGrooveThickness(const qreal grooveThickness)
{
    Q_D(BreezeDial);
    if (d->grooveThickness == grooveThickness)
        return;

    d->grooveThickness = grooveThickness;
    update();
    Q_EMIT grooveThicknessChanged();
}

bool BreezeDial::notchesVisible() const
{
    Q_D(const BreezeDial);
    return d->notchesVisible;
}

void BreezeDial::setNotchesVisible(const qreal notchesVisible)
{
    Q_D(BreezeDial);
    if (d->notchesVisible == notchesVisible)
        return;

    d->notchesVisible = notchesVisible;
    update();
    Q_EMIT notchesVisibleChanged();
}

#include "moc_breezedial.cpp"
