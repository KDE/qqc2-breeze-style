/* SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
 */

#ifndef TEXTACTIONSMENUATTACHED_H
#define TEXTACTIONSMENUATTACHED_H

#include <QObject>
#include <QQmlComponent>

class TextActionsMenuAttachedPrivate;

// Based on QQuickToolTipAttached
class TextActionsMenuAttached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject *menu READ menu CONSTANT FINAL)
    // Used to switch between touch screen and mouse oriented forms.
    Q_PROPERTY(bool touchScreenMode READ touchScreenMode WRITE setTouchScreenMode NOTIFY touchScreenModeChanged FINAL)
    Q_PROPERTY(int timeout READ timeout WRITE setTimeout NOTIFY timeoutChanged FINAL)
    // visible doesn't really work like visible typically does, but this is what QQuickToolTipAttached does too.
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged FINAL)
    // Used to disable the menu when you don't want it.
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged FINAL)

public:
    explicit TextActionsMenuAttached(QObject *parent = nullptr);

    QObject *menu() const;

    bool touchScreenMode() const;
    void setTouchScreenMode(bool touchScreenMode);

    int timeout() const;
    void setTimeout(int timeout);

    bool isVisible() const;
    void setVisible(bool visible);

    bool enabled() const;
    void setEnabled(bool enabled);

Q_SIGNALS:
    void touchScreenModeChanged();
    void timeoutChanged();
    void visibleChanged();
    void enabledChanged();

public Q_SLOTS:
    // Behaves like QQuickToolTipAttached::show()
    void show(int timeout = -1);
    // Invokes QQuickMenu::dismiss()
    void dismiss();

private:
    const QScopedPointer<TextActionsMenuAttachedPrivate> d_ptr;
    Q_DECLARE_PRIVATE(TextActionsMenuAttached)
    Q_DISABLE_COPY(TextActionsMenuAttached)
};

QML_DECLARE_TYPEINFO(TextActionsMenuAttached, QML_HAS_ATTACHED_PROPERTIES)

#endif // TEXTACTIONSMENUATTACHED_H
