/*
 * SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
 * SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>
 * SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later OR LicenseRef-KDE-Accepted-LGPL OR LicenseRef-KFQF-Accepted-GPL
 */

#ifndef QQC2BREEZESTYLEPLUGIN_H
#define QQC2BREEZESTYLEPLUGIN_H

#include "impl/qqc2breezeglobal_p.h"

#include <QQmlExtensionPlugin>

BEGIN_NAMESPACE_QQC2Breeze

class QQC2BreezeStylePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    QQC2BreezeStylePlugin(QObject *parent = nullptr);
    ~QQC2BreezeStylePlugin();

    QString name() const;

    void registerTypes(const char *uri) override;

private:
    // I'm doing this just because that's what QQuickStylePlugin does
    Q_DISABLE_COPY(QQC2BreezeStylePlugin)
};

END_NAMESPACE
#endif
