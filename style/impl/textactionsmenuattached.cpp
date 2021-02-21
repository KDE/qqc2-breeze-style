/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
 */

#include "textactionsmenuattached.h"
#include "textactionsmenuattached_p.h"

QObject *TextActionsMenuAttachedPrivate::instance(bool create) const
{
    Q_Q(const TextActionsMenuAttached);
    QQmlEngine *engine = qmlEngine(q->parent());
    if (!engine)
        return nullptr;

    static const char *name = "_qqc2breeze_TextActionsMenu";

    QObject *menu = engine->property(name).value<QObject *>();
    if (!menu && create) {
        // TODO: a cleaner way to create the instance? QQml(Meta)Type?
        QQmlComponent component(engine);
        component.setData("import QtQuick.Controls; Menu { }", QUrl());

        QObject *object = component.create();
        if (object)
            object->setParent(engine);

        menu = qobject_cast<QObject *>(object);
        if (!menu)
            delete object;
        else
            engine->setProperty(name, QVariant::fromValue(object));
    }
    return menu;
}

void TextActionsMenuAttachedPrivate::createMenu()
{
    Q_Q(TextActionsMenuAttached);
}

void TextActionsMenuAttachedPrivate::destroyMenu()
{
    Q_Q(TextActionsMenuAttached);
}

void TextActionsMenuAttachedPrivate::open()
{
    Q_Q(TextActionsMenuAttached);
    menuObject->setProperty("parentItem", qobject_cast<const QQuickItem*>(q->parent()));

    if(touchScreenMode) {
        // Open the menu at (0, parentItem->height()), relative to the parentItem
        QMetaObject::invokeMethod(menuObject, "popup", Q_ARG(qreal, 0), Q_ARG(qreal, q->parent()->property("height").toReal()));
    } else {
        // Open the menu at the mouse cursor position
        QMetaObject::invokeMethod(menuObject, "popup");
    }
}

TextActionsMenuAttached::TextActionsMenuAttached(QObject *parent)
    : QObject(parent)
    , d_ptr(new TextActionsMenuAttachedPrivate(this))
{
}

QObject * TextActionsMenuAttached::menu() const
{
    Q_D(const TextActionsMenuAttached);
    return d->menuObject;
}

bool TextActionsMenuAttached::touchScreenMode() const
{
    Q_D(const TextActionsMenuAttached);
}

void TextActionsMenuAttached::setTouchScreenMode(bool touchScreenMode)
{
    Q_D(const TextActionsMenuAttached);
}

int TextActionsMenuAttached::timeout() const
{
    Q_D(const TextActionsMenuAttached);
    return d->timeout;
}

void TextActionsMenuAttached::setTimeout(int timeout)
{
    Q_D(TextActionsMenuAttached);
    if (d->timeout == timeout) {
        return;
    }

    d->timeout = timeout;
    emit timeoutChanged();

    if (isVisible()) {
        d->instance(true)->setProperty("timeout", timeout);
    }
}

bool TextActionsMenuAttached::isVisible() const
{
    Q_D(const TextActionsMenuAttached);
    return d->menuObject && d->menuObject->property("visible").toBool() && parent() == d->menuObject->property("parentItem").value<QQuickItem*>();
}

void TextActionsMenuAttached::setVisible(bool visible)
{
    Q_D(TextActionsMenuAttached);
    if (d->visible == visible) {
        return;
    }

    d->visible = visible;
    emit visibleChanged();

    if (d->visible) {
        d->open();
    } else {
        dismiss();
    }
}

bool TextActionsMenuAttached::enabled() const
{
    Q_D(const TextActionsMenuAttached);
    return d->enabled;
}

void TextActionsMenuAttached::setEnabled(bool enabled)
{
    Q_D(TextActionsMenuAttached);
    if(d->enabled == enabled) {
        return;
    }

    d->enabled = enabled;
    emit enabledChanged();
}

void TextActionsMenuAttached::show(int timeout)
{
    Q_D(TextActionsMenuAttached);
    if(!d->menuObject || !d->enabled) {
        return;
    }

    // Using this because it's possible to call these functions without setting visible
    setVisible(true);
    d->menuObject->setProperty("timeout", timeout >= 0 ? timeout : d->timeout);
}

void TextActionsMenuAttached::dismiss()
{
    Q_D(TextActionsMenuAttached);
    if (!d->menuObject) {
        return;
    }

    // Using this because it's possible to call these functions without setting visible
    setVisible(false);

    if (parent() == d->menuObject->property("parentItem").value<QQuickItem*>()) {
        QMetaObject::invokeMethod(d->menuObject, "dismiss");
    }
}
