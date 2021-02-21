#ifndef TEXTACTIONSMENUATTACHED_P_H
#define TEXTACTIONSMENUATTACHED_P_H


#include "textactionsmenuattached.h"

#include <QQmlEngine>
#include <QQuickItem>

class TextActionsMenuAttachedPrivate
{
    Q_DECLARE_PUBLIC(TextActionsMenuAttached)
    Q_DISABLE_COPY(TextActionsMenuAttachedPrivate)
public:
    TextActionsMenuAttachedPrivate(TextActionsMenuAttached *qq) : q_ptr(qq) {}

    TextActionsMenuAttached * const q_ptr = nullptr;

    void open();
    QObject *instance(bool create) const;
    void createMenu();
    void destroyMenu();
    QPointer<QQmlComponent> menuComponent;
    //QQuickMenu is based on QQuickPopup which is based on QObject, not QQuickItem
    QPointer<QObject> menuObject;
    bool touchScreenMode = false;
    int timeout = -1;
    bool visible = false;
    bool enabled = true;
};

#endif
