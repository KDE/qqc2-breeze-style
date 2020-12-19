/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

#ifndef PAINTEDSYMBOLITEM_H
#define PAINTEDSYMBOLITEM_H

#include <QtQuick>

class PaintedSymbolItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(qreal penWidth READ penWidth NOTIFY penWidthChanged)
    Q_PROPERTY(SymbolType symbolType READ symbolType WRITE setSymbolType NOTIFY symbolTypeChanged)
    QML_ELEMENT

public:
    enum SymbolType {
        Checkmark
    };
    Q_ENUM(SymbolType)

    PaintedSymbolItem(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    QColor color() const;
    void setColor(const QColor &color);

    qreal penWidth() const;
    void setPenWidth(const qreal penWidth);

    SymbolType symbolType() const;
    void setSymbolType(const SymbolType symbolType);

Q_SIGNALS:
    void colorChanged();
    void penWidthChanged();
    void symbolTypeChanged();

private:
    QColor m_color;
    qreal m_penWidth = 1.001; // 1 causes weird distortion
    SymbolType m_symbolType;

    QPen m_pen = QPen(m_color, m_penWidth, Qt::SolidLine, Qt::SquareCap, Qt::MiterJoin);
};

#endif
