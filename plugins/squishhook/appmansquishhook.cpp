/****************************************************************************
**
** Copyright (C) 2019 froglogic GmbH
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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

#include "appmansquishhook.h"

#include "qtbuiltinhook.h"

#include <qdebug.h>
#include <qqmlengine.h>
#include <qqmlcontext.h>

AppmanSquishhook::AppmanSquishhook()
    : port( -1 ),
      listening( false )
{}

void AppmanSquishhook::initialize(const QVariantMap &systemProperties) Q_DECL_NOEXCEPT_EXPR(false)
{
    QVariantMap::const_iterator portIt = systemProperties.find( "squishPort" );
    if ( portIt != systemProperties.end() ) {
        bool ok = false;
        int p = portIt->toInt( &ok );
        if ( ok ) {
            port = p;
        } else {
            qDebug() << "squishPort system property is invalid";
        }
    }
}

void AppmanSquishhook::afterRuntimeRegistration() Q_DECL_NOEXCEPT_EXPR(false)
{}

void AppmanSquishhook::beforeQmlEngineLoad(QQmlEngine *engine) Q_DECL_NOEXCEPT_EXPR(false)
{
    if ( listening ) {
        return;
    }

    listening = true;
    int p = getApplicationPort( engine );
    if ( p > 0 ) {
        port = p;
    }
    qDebug() << "squishPort is set to " << port;
    if ( port > 0 ) {
        Squish::allowAttaching( port );
    }
}

void AppmanSquishhook::afterQmlEngineLoad(QQmlEngine *) Q_DECL_NOEXCEPT_EXPR(false)
{}

void AppmanSquishhook::beforeWindowShow(QWindow *) Q_DECL_NOEXCEPT_EXPR(false)
{}

void AppmanSquishhook::afterWindowShow(QWindow *) Q_DECL_NOEXCEPT_EXPR(false)
{}

int AppmanSquishhook::getApplicationPort(QQmlEngine* engine)
{
    QVariant ai = engine->rootContext()->contextProperty( "ApplicationInterface" );
    if ( !ai.isValid() ) {
        qDebug() << "ApplicationInterface is not present";
        return -1;
    }
    QObject* aio = ai.value<QObject*>();
    if ( !aio ) {
        qDebug() << "ApplicationInterface is not a QObject";
        return -1;
    }
    QVariant appProps = aio->property( "applicationProperties" );
    if ( appProps.type() != QVariant::Map ) {
        qDebug() << "ApplicationInterface has no applicationProperties map";
        return -1;
    }
    QVariantMap appPropsMap = appProps.toMap();
    QVariantMap::const_iterator it = appPropsMap.find( "squishPort" );
    if ( it == appPropsMap.end() ) {
        qDebug() << "applicationProperties do not specify squish port";
        return -1;
    }
    bool ok = false;
    int port = it->toInt( &ok );
    if ( !ok ) {
        qDebug() << "squishPort is not a valid string";
        return -1;
    }
    return port;
}
