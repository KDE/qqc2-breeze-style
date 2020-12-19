/* SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

#include "paintedsymbolitem.h"
#include <QPainter>

PaintedSymbolItem::PaintedSymbolItem(QQuickItem *parent) : QQuickPaintedItem(parent)
{
}

void PaintedSymbolItem::paint(QPainter *painter)
{
    // Do I need to save() and restore() if I change the painter in the switch blocks?
    switch (m_symbolType) {
        case SymbolType::Checkmark: {

            this->setPenWidth(2);
            qreal penOffset = m_penWidth/2;

            // Prevent the sides from being cut off. Remember to add extra width and height externally.
            qreal width = this->width() - m_penWidth;
            qreal height = this->height() - m_penWidth;
            painter->translate(penOffset, penOffset);

            painter->setBrush(Qt::NoBrush);
            painter->setPen(m_pen);
            painter->setRenderHint(QPainter::Antialiasing);

            QVector<QPointF> points = {
                QPointF(0 + penOffset, height/2.0 + penOffset),
                QPointF(width/3.0, height/1.2), //height * (5/6)
                QPointF(width - penOffset, height/6.0 + penOffset)
            };
            painter->drawPolyline(points);

        } break;
        default:
            break;
    }
}

// color
QColor PaintedSymbolItem::color() const
{
    return this->m_color;
}

void PaintedSymbolItem::setColor(const QColor &color)
{
    if (color == m_color) {
        return;
    }

    this->m_color = color;
    m_pen.setColor(m_color);
    update();
    emit colorChanged();
}

// penWidth
qreal PaintedSymbolItem::penWidth() const
{
    return this->m_penWidth;
}

void PaintedSymbolItem::setPenWidth(const qreal penWidth)
{
    if (penWidth == m_penWidth || (m_penWidth == 1.001 && penWidth == 1)) {
        return;
    }

    this->m_penWidth = penWidth == 1 ? 1.001 : penWidth;
    m_pen.setWidthF(m_penWidth);
//     update();
    emit penWidthChanged();
}

// symbolType
PaintedSymbolItem::SymbolType PaintedSymbolItem::symbolType() const
{
    return this->m_symbolType;
}

void PaintedSymbolItem::setSymbolType(const SymbolType symbolType)
{
    if (symbolType == m_symbolType) {
        return;
    }

    this->m_symbolType = symbolType;
    update();
    emit symbolTypeChanged();
}
