/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

#include "neptunestyleplugin.h"

#include <QtQml>
#include "neptunestyle.h"
#include "neptunetheme.h"

Q_LOGGING_CATEGORY(neptuneStyle, "neptune.style")


NeptuneStylePlugin::NeptuneStylePlugin(QObject *parent)
    : QQuickStylePlugin(parent)
{ }

void NeptuneStylePlugin::registerTypes(const char *uri)
{
    qmlRegisterUncreatableType<NeptuneStyle>(uri, 3, 0, "NeptuneStyle", "NeptuneStyle is an attached property");
}

void NeptuneStylePlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQuickStylePlugin::initializeEngine(engine, uri);
}

QString NeptuneStylePlugin::name() const
{
    return QStringLiteral("neptune");
}

QQuickProxyTheme *NeptuneStylePlugin::createTheme() const
{
    qCDebug(neptuneStyle) << "Created a NeptuneTheme instance";
    return new NeptuneTheme;
}
