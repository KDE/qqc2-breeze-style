/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

#ifndef BREEZEDIAL_H
#define BREEZEDIAL_H

#include <QColor>
#include <QQuickPaintedItem>

class BreezeDialPrivate;

class BreezeDial : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor backgroundBorderColor READ backgroundBorderColor WRITE setBackgroundBorderColor NOTIFY backgroundBorderColorChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(QColor fillBorderColor READ fillBorderColor WRITE setFillBorderColor NOTIFY fillBorderColorChanged)
    Q_PROPERTY(QColor fillColor READ fillColor WRITE setFillColor NOTIFY fillColorChanged)
    Q_PROPERTY(qreal angle READ angle WRITE setAngle NOTIFY angleChanged)
    Q_PROPERTY(qreal grooveThickness READ grooveThickness WRITE setGrooveThickness NOTIFY grooveThicknessChanged)
    Q_PROPERTY(bool notchesVisible READ notchesVisible WRITE setNotchesVisible NOTIFY notchesVisibleChanged)
    QML_NAMED_ELEMENT(BreezeDial)

public:
    explicit BreezeDial(QQuickItem *parent = nullptr);
    ~BreezeDial();

    void paint(QPainter *painter) override;

    QColor backgroundBorderColor() const;
    void setBackgroundBorderColor(const QColor &color);

    QColor backgroundColor() const;
    void setBackgroundColor(const QColor &color);

    QColor fillBorderColor() const;
    void setFillBorderColor(const QColor &color);

    QColor fillColor() const;
    void setFillColor(const QColor &color);

    qreal angle() const;
    void setAngle(const qreal angle);

    qreal grooveThickness() const;
    void setGrooveThickness(const qreal grooveThickness);

    bool notchesVisible() const;
    void setNotchesVisible(const qreal notchesVisible);

Q_SIGNALS:
    void backgroundBorderColorChanged();
    void backgroundColorChanged();
    void fillBorderColorChanged();
    void fillColorChanged();
    void angleChanged();
    void grooveThicknessChanged();
    void notchesVisibleChanged();

private:
    const std::unique_ptr<BreezeDialPrivate> d_ptr;
    Q_DECLARE_PRIVATE(BreezeDial)
    Q_DISABLE_COPY(BreezeDial)
};

#endif
