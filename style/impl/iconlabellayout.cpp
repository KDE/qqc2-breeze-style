/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
 */

#include "iconlabellayout.h"
#include "iconlabellayout_p.h"

#include <QGuiApplication>

#include <unordered_map>
#include <cmath>

void IconLabelLayout::Private::setInitialIconItemProperties()
{
    initialIconItemProperties = {
        {QStringLiteral("source"), icon.nameOrSource()},
        {QStringLiteral("implicitWidth"), icon.width()},
        {QStringLiteral("implicitHeight"), icon.height()},
        {QStringLiteral("color"), icon.color()},
        {QStringLiteral("cache"), icon.cache()}
    };
}

bool IconLabelLayout::Private::createIconItem()
{
    if (iconItem)
        return false;

    //setInitialIconItemProperties();
    // Using createWithInitialProperties() causes an invalid address segfault;
    iconItem = qobject_cast<QQuickItem*>(iconComponent->create());
    iconItem->setParentItem(q);
    iconItem->setObjectName(QStringLiteral("iconItem"));
    syncIconItem();
    return true;
}

bool IconLabelLayout::Private::destroyIconItem()
{
    if (!iconItem)
        return false;

//     unwatchChanges(iconItem);
    iconItem->deleteLater();
    iconItem = nullptr;
    return true;
}

bool IconLabelLayout::Private::updateIconItem()
{
    if (!q->hasIcon())
        return destroyIconItem();
    return createIconItem();
}

void IconLabelLayout::Private::syncIconItem()
{
    if (!iconItem || icon.isEmpty())
        return;

    iconItem->setProperty("source", icon.nameOrSource());
    iconItem->setProperty("implicitWidth", icon.width());
    iconItem->setProperty("implicitHeight", icon.height());
    iconItem->setProperty("color", icon.color());
    iconItem->setProperty("cache", icon.cache());
}

void IconLabelLayout::Private::updateOrSyncIconItem()
{
    if (updateIconItem()) {
        if (q->isComponentComplete()) {
            updateImplicitSize();
            layout();
        }
    } else {
        syncIconItem();
    }
}

void IconLabelLayout::Private::setInitialLabelItemProperties()
{
    const int halign = alignment & Qt::AlignHorizontal_Mask;
    const int valign = alignment & Qt::AlignVertical_Mask;
    initialLabelItemProperties = {
        {QStringLiteral("text"), text},
        {QStringLiteral("font"), font},
        {QStringLiteral("color"), color},
        {QStringLiteral("horizontalAlignment"), halign},
        {QStringLiteral("verticalAlignment"), valign}
    };
}

bool IconLabelLayout::Private::createLabelItem()
{
    if (labelItem)
        return false;

    setInitialLabelItemProperties();
    labelItem = qobject_cast<QQuickItem*>(labelComponent->createWithInitialProperties(initialLabelItemProperties));
    labelItem->setParentItem(q);
    labelItem->setObjectName(QStringLiteral("labelItem"));
//     syncLabelItem();
    return true;
}

bool IconLabelLayout::Private::destroyLabelItem()
{
    if (!labelItem)
        return false;

//     unwatchChanges(labelItem);
    labelItem->deleteLater();
    labelItem = nullptr;
    return true;
}

bool IconLabelLayout::Private::updateLabelItem()
{
    if (!q->hasLabel())
        return destroyLabelItem();
    return createLabelItem();
}

void IconLabelLayout::Private::syncLabelItem()
{
    if (!labelItem)
        return;

    labelItem->setProperty("text", text);
//     labelItem->setProperty("font", font);
//     labelItem->setProperty("color", color);
//     const int halign = alignment & Qt::AlignHorizontal_Mask;
//     labelItem->setProperty("horizontalAlignment", halign);
//     const int valign = alignment & Qt::AlignVertical_Mask;
//     labelItem->setProperty("verticalAlignment", valign);
}

void IconLabelLayout::Private::updateOrSyncLabelItem()
{
    if (updateLabelItem()) {
        if (q->isComponentComplete()) {
            updateImplicitSize();
            layout();
        }
    } else {
        syncLabelItem();
    }
}

void IconLabelLayout::Private::updateImplicitSize()
{
    bool showIcon = iconItem && q->hasIcon();
    bool showLabel = labelItem && q->hasLabel();

    const qreal iconImplicitWidth = showIcon ? iconItem->implicitWidth() : 0;
    const qreal iconImplicitHeight = showIcon ? iconItem->implicitHeight() : 0;
    // Always ceil text size to prevent pixel misalignment. If you use round or floor, you may cause text elision.
    const qreal labelImplicitWidth = showLabel ? std::ceil(labelItem->implicitWidth()) : 0;
    const qreal labelImplicitHeight = showLabel ? std::ceil(labelItem->implicitHeight()) : 0;
    const qreal effectiveSpacing = showLabel && showIcon && iconItem->implicitWidth() > 0 ? spacing : 0;
    contentWidth = display == Display::TextBesideIcon ?
        iconImplicitWidth + labelImplicitWidth + effectiveSpacing : qMax(iconImplicitWidth, labelImplicitWidth);
    contentHeight = display == Display::TextUnderIcon ?
        iconImplicitHeight + labelImplicitHeight + effectiveSpacing : qMax(iconImplicitHeight, labelImplicitHeight);
    q->setImplicitSize(contentWidth + leftPadding + rightPadding, contentHeight + topPadding + bottomPadding);
    q->setAvailableWidth();
    q->setAvailableHeight();
}

static QRectF alignedRect(bool mirrored, Qt::Alignment alignment, const QSizeF &size, const QRectF &rectangle)
{
    Qt::Alignment halign = alignment & Qt::AlignHorizontal_Mask;
    if (mirrored && (halign & Qt::AlignRight) == Qt::AlignRight) {
        halign = Qt::AlignLeft;
    } else if (mirrored && (halign & Qt::AlignLeft) == Qt::AlignLeft) {
        halign = Qt::AlignRight;
    }
    qreal x = rectangle.x();
    qreal y = rectangle.y();
    const qreal w = size.width();
    const qreal h = size.height();
    if ((alignment & Qt::AlignVCenter) == Qt::AlignVCenter)
        y += rectangle.height() / 2 - h / 2;
    else if ((alignment & Qt::AlignBottom) == Qt::AlignBottom)
        y += rectangle.height() - h;
    if ((halign & Qt::AlignRight) == Qt::AlignRight)
        x += rectangle.width() - w;
    else if ((halign & Qt::AlignHCenter) == Qt::AlignHCenter)
        x += rectangle.width() / 2 - w / 2;
    return QRectF(x, y, w, h);
}

void IconLabelLayout::Private::layout()
{
    if (!q->isComponentComplete())
        return;

    switch (display) {
    case Display::IconOnly:
        if (iconItem) {
            // Icons should always be pixel aligned, so convert to QRect
            q->setIconRect(alignedRect(mirrored, alignment,
                                        QSizeF(qMin(iconItem->implicitWidth(), q->availableWidth()),
                                                qMin(iconItem->implicitHeight(), q->availableHeight())),
                                        QRectF(mirrored ? rightPadding : leftPadding, topPadding, q->availableWidth(), q->availableHeight())));
            iconItem->setSize(iconRect.size());
            iconItem->setPosition(iconRect.topLeft()); // Not animating icon positions because it tends to look wrong
        }
        break;
    case Display::TextOnly:
        if (labelItem) {
            q->setLabelRect(alignedRect(mirrored, alignment,
                                        QSizeF(qMin(labelItem->implicitWidth(), q->availableWidth()),
                                                qMin(labelItem->implicitHeight(), q->availableHeight())),
                                        QRectF(mirrored ? rightPadding : leftPadding, topPadding, q->availableWidth(), q->availableHeight())));
            labelItem->setSize(labelRect.size());
            labelItem->setPosition(labelRect.topLeft()); // Not animating when text only because the text tends to clip outside
        }
        break;

    case Display::TextUnderIcon: {
        // Work out the sizes first, as the positions depend on them.
        QSizeF iconSize;
        QSizeF textSize;
        if (iconItem) {
            iconSize.setWidth(qMin(iconItem->implicitWidth(), q->availableWidth()));
            iconSize.setHeight(qMin(iconItem->implicitHeight(), q->availableHeight()));
        }
        qreal effectiveSpacing = 0;
        if (labelItem) {
            if (!iconSize.isEmpty())
                effectiveSpacing = spacing;
            textSize.setWidth(qMin(labelItem->implicitWidth(), q->availableWidth()));
            textSize.setHeight(qMin(labelItem->implicitHeight(), q->availableHeight() - iconSize.height() - effectiveSpacing));
        }

        QRectF combinedRect = alignedRect(mirrored, alignment,
                                          QSizeF(qMax(iconSize.width(), textSize.width()),
                                                 iconSize.height() + effectiveSpacing + textSize.height()),
                                          QRectF(mirrored ? rightPadding : leftPadding, topPadding, q->availableWidth(), q->availableHeight()));
        q->setIconRect(alignedRect(mirrored, Qt::AlignHCenter | Qt::AlignTop, iconSize, combinedRect));
        q->setLabelRect(alignedRect(mirrored, Qt::AlignHCenter | Qt::AlignBottom, textSize, combinedRect));
        if (iconItem) {
            iconItem->setSize(iconRect.size());
            iconItem->setPosition(iconRect.topLeft());
        }
        if (labelItem) {
            labelItem->setSize(labelRect.size());
            labelItem->setPosition(labelRect.topLeft());
//             labelItem->setOpacity(0);
//             labelItem->setY(iconRect.y() + iconRect.height());
//             labelItem->setProperty("opacity", 1);
//             labelItem->setX(labelRect.x()); // Not animating X so that the text will only slide vertically
//             labelItem->setProperty("y", labelRect.y());
        }
        break;
    }

    case Display::TextBesideIcon:
    default:
        // Work out the sizes first, as the positions depend on them.
        QSizeF iconSize(0, 0);
        QSizeF textSize(0, 0);
        if (iconItem) {
            iconSize.setWidth(qMin(iconItem->implicitWidth(), q->availableWidth()));
            iconSize.setHeight(qMin(iconItem->implicitHeight(), q->availableHeight()));
        }
        qreal effectiveSpacing = 0;
        if (labelItem) {
            if (!iconSize.isEmpty())
                effectiveSpacing = spacing;
            textSize.setWidth(qMin(labelItem->implicitWidth(), q->availableWidth() - iconSize.width() - effectiveSpacing));
            textSize.setHeight(qMin(labelItem->implicitHeight(), q->availableHeight()));
        }

        const QRectF combinedRect = alignedRect(mirrored, alignment,
                                                QSizeF(iconSize.width() + effectiveSpacing + textSize.width(),
                                                       qMax(iconSize.height(), textSize.height())),
                                                QRectF(mirrored ? rightPadding : leftPadding, topPadding, q->availableWidth(), q->availableHeight()));
        q->setIconRect(alignedRect(mirrored, Qt::AlignLeft | Qt::AlignVCenter, iconSize, combinedRect));
        q->setLabelRect(alignedRect(mirrored, Qt::AlignRight | Qt::AlignVCenter, textSize, combinedRect));
        if (iconItem) {
            iconItem->setSize(iconRect.size());
            iconItem->setPosition(iconRect.topLeft());
        }
        if (labelItem) {
            labelItem->setSize(labelRect.size());
            labelItem->setPosition(labelRect.topLeft());
//             labelItem->setOpacity(0);
//             labelItem->setX(iconRect.x() + (mirrored ? -labelRect.width() : iconRect.width()));
//             labelItem->setProperty("opacity", 1);
//             labelItem->setProperty("x", labelRect.x());
//             labelItem->setY(labelRect.y()); // Not animating Y so that the text will only slide horizontally
        }
        break;
    }

    q->setBaselineOffset(labelItem ? labelItem->y() + labelItem->baselineOffset() : 0);
    if (!firstLayoutCompleted) {
        firstLayoutCompleted = true;
        if (iconItem) {
            iconItem->setProperty("firstLayoutCompleted", true);
        }
        if (labelItem) {
            labelItem->setProperty("firstLayoutCompleted", true);
        }
    }
//     qDebug() << q << "d->layout()" << layoutCount;
//     layoutCount += 1;
}

IconLabelLayout::IconLabelLayout(QQuickItem *parent)
    : QQuickItem(parent)
    , d(new Private(this))
{
}

IconLabelLayout::~IconLabelLayout()
{
}

QQmlComponent *IconLabelLayout::iconComponent() const
{
    return d->iconComponent;
}

void IconLabelLayout::setIconComponent(QQmlComponent *iconComponent)
{
    if (iconComponent == d->iconComponent) {
        return;
    }

    d->iconComponent = iconComponent;
    d->updateOrSyncIconItem();
    emit iconComponentChanged();
}

QQmlComponent *IconLabelLayout::labelComponent() const
{
    return d->labelComponent;
}

void IconLabelLayout::setLabelComponent(QQmlComponent *labelComponent)
{
    if (labelComponent == d->labelComponent) {
        return;
    }

    d->labelComponent = labelComponent;
    d->updateOrSyncLabelItem();
    emit labelComponentChanged();
}

bool IconLabelLayout::hasIcon() const
{
    return d->hasIcon;
}

void IconLabelLayout::setHasIcon()
{
    if (d->hasIcon == !textOnly() && !d->icon.isEmpty()) {
        return;
    }

    d->hasIcon = !textOnly() && !d->icon.isEmpty();
    emit hasIconChanged();
}

bool IconLabelLayout::hasLabel() const
{
    return d->hasLabel;
}

void IconLabelLayout::setHasLabel()
{
    if (d->hasLabel == !iconOnly() && !d->text.isEmpty()) {
        return;
    }

    d->hasLabel = !iconOnly() && !d->text.isEmpty();
    emit hasLabelChanged();
}

QQuickIcon IconLabelLayout::icon() const
{
    return d->icon;
}

void IconLabelLayout::setIcon(const QQuickIcon &icon)
{
    if (icon == d->icon) {
        return;
    }

    d->icon = icon;
    setHasIcon();
    d->updateOrSyncIconItem();

    emit iconChanged();
}

QString IconLabelLayout::text() const
{
    return d->text;
}

void IconLabelLayout::setText(const QString &text)
{
    if (text == d->text) {
        return;
    }

    d->text = text;
    setHasLabel();
    d->updateOrSyncLabelItem();
    emit textChanged(text);
}

QFont IconLabelLayout::font() const
{
    return d->font;
}

void IconLabelLayout::setFont(const QFont &font)
{
    if (font == d->font) {
        return;
    }

    d->font = font;
    if (d->labelItem) {
        d->labelItem->setProperty("font", font);
    } else {
        d->initialLabelItemProperties[QStringLiteral("font")] = font;
    }
    emit fontChanged(font);
}

QColor IconLabelLayout::color() const
{
    return d->color;
}

void IconLabelLayout::setColor(const QColor &color)
{
    if (color == d->color) {
        return;
    }

    d->color = color;
    if (d->labelItem) {
        d->labelItem->setProperty("color", color);
    }

    emit colorChanged();
}

QRectF IconLabelLayout::iconRect() const
{
    return d->iconRect;
}

void IconLabelLayout::setIconRect(const QRectF &rect)
{
    // Icons should always be pixel aligned
    QRectF alignedRect = rect.toAlignedRect();
    if (d->iconRect == alignedRect) {
        return;
    }

    d->iconRect = alignedRect;
    emit iconRectChanged();
}

QRectF IconLabelLayout::labelRect() const
{
    return d->labelRect;
}

void IconLabelLayout::setLabelRect(const QRectF &rect)
{
    if (d->labelRect == rect) {
        return;
    }

    d->labelRect = rect;
    emit labelRectChanged();
}

qreal IconLabelLayout::availableWidth() const
{
    return d->availableWidth;
}

void IconLabelLayout::setAvailableWidth()
{
    qreal newAvailableWidth = std::max(0.0, width() - leftPadding() - rightPadding());
    if (d->availableWidth == newAvailableWidth) {
        return;
    }

    d->availableWidth = newAvailableWidth;
    emit availableWidthChanged();
}

qreal IconLabelLayout::availableHeight() const
{
    return d->availableHeight;
}

void IconLabelLayout::setAvailableHeight()
{
    qreal newAvailableHeight = std::max(0.0, height() - topPadding() - bottomPadding());
    if (d->availableHeight == newAvailableHeight) {
        return;
    }

    d->availableHeight = newAvailableHeight;
    emit availableHeightChanged();
}

qreal IconLabelLayout::spacing() const
{
    return d->spacing;
}

void IconLabelLayout::setSpacing(qreal spacing)
{
    if (spacing == d->spacing) {
        return;
    }

    d->spacing = spacing;
    emit spacingChanged();
    if (d->iconItem && d->labelItem) {
        relayout();
    }
}

qreal IconLabelLayout::leftPadding() const
{
    return d->leftPadding;
}

void IconLabelLayout::setLeftPadding(qreal leftPadding)
{
    if (leftPadding == d->leftPadding) {
        return;
    }

    d->leftPadding = leftPadding;
    emit leftPaddingChanged();
    relayout();
}

qreal IconLabelLayout::rightPadding() const
{
    return d->rightPadding;
}

void IconLabelLayout::setRightPadding(qreal rightPadding)
{
    if (rightPadding == d->rightPadding) {
        return;
    }

    d->rightPadding = rightPadding;
    emit rightPaddingChanged();
    relayout();
}

qreal IconLabelLayout::topPadding() const
{
    return d->topPadding;
}

void IconLabelLayout::setTopPadding(qreal topPadding)
{
    if (topPadding == d->topPadding) {
        return;
    }

    d->topPadding = topPadding;
    emit topPaddingChanged();
    relayout();
}

qreal IconLabelLayout::bottomPadding() const
{
    return d->bottomPadding;
}

void IconLabelLayout::setBottomPadding(qreal bottomPadding)
{
    if (bottomPadding == d->bottomPadding) {
        return;
    }

    d->bottomPadding = bottomPadding;
    emit bottomPaddingChanged();
    relayout();
}

bool IconLabelLayout::mirrored() const
{
    return d->mirrored;
}

void IconLabelLayout::setMirrored(bool mirrored)
{
    if (mirrored == d->mirrored) {
        return;
    }

    d->mirrored = mirrored;
    emit mirroredChanged();
    if (isComponentComplete()) {
        d->layout();
    }
}

Qt::Alignment IconLabelLayout::alignment() const
{
    return d->alignment;
}

void IconLabelLayout::setAlignment(Qt::Alignment alignment)
{
    const int valign = alignment & Qt::AlignVertical_Mask;
    const int halign = alignment & Qt::AlignHorizontal_Mask;
    const uint align = (valign ? valign : Qt::AlignVCenter) | (halign ? halign : Qt::AlignHCenter);
    if (d->alignment == align) {
        return;
    }

    d->alignment = static_cast<Qt::Alignment>(align);
    if (d->labelItem) {
        d->labelItem->setProperty("horizontalAlignment", halign);
        d->labelItem->setProperty("verticalAlignment", valign);

    }
    emit alignmentChanged();
    if (isComponentComplete()) {
        d->layout();
    }
}

IconLabelLayout::Display IconLabelLayout::display() const
{
    return d->display;
}

void IconLabelLayout::setDisplay(IconLabelLayout::Display display)
{
    Display oldDisplay = d->display;
    if (display == oldDisplay) {
        return;
    }

    d->display = display;
    emit displayChanged();

    if (oldDisplay == iconOnly()) {
        emit iconOnlyChanged();
    } else if (oldDisplay == textOnly()) {
        emit textOnlyChanged();
    } else if (oldDisplay == textBesideIcon()) {
        emit textBesideIconChanged();
    } else if (oldDisplay == textUnderIcon()) {
        emit textUnderIconChanged();
    }

    setHasIcon();
    setHasLabel();

    d->updateIconItem();
    d->updateLabelItem();
    relayout();
}

bool IconLabelLayout::iconOnly() const
{
    return d->display == Display::IconOnly;
}

bool IconLabelLayout::textOnly() const
{
    return d->display == Display::TextOnly;
}

bool IconLabelLayout::textBesideIcon() const
{
    return d->display == Display::TextBesideIcon;
}

bool IconLabelLayout::textUnderIcon() const
{
    return d->display == Display::TextUnderIcon;
}

void IconLabelLayout::relayout()
{
    if (isComponentComplete()) {
        d->updateImplicitSize();
        d->layout();
    }
}

void IconLabelLayout::componentComplete()
{
    QQuickItem::componentComplete();
    relayout();
}

void IconLabelLayout::geometryChanged(const QRectF& newGeometry, const QRectF& oldGeometry)
{
    if (newGeometry != oldGeometry) {
        setAvailableWidth();
        setAvailableHeight();
        relayout();
    }
    QQuickItem::geometryChanged(newGeometry, oldGeometry);
}
