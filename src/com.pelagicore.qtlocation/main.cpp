/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

#include <QtAppManLauncher/private/applicationmanagerwindow_p.h>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QDir>

// code to transform a macro into a string literal
#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)

QT_USE_NAMESPACE_AM

void copyOfflineDB(const QString &prefix) {
    const QString sourceFile = prefix + QStringLiteral("maps/mapboxgl.db");
    const QString destDir = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
    const QString destFile = destDir + QStringLiteral("/mapboxgl.db");
    QDir dir;
    dir.mkpath(destDir);
    QFile::remove(destFile);
    QFile::copy(sourceFile, destFile);
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // same as the main app so that we get the same predictable subdir under ~/.cache
    QCoreApplication::setApplicationName(qSL("Triton UI"));
    QCoreApplication::setOrganizationName(qSL("Pelagicore AG"));
    QCoreApplication::setOrganizationDomain(qSL("pelagicore.com"));

    QGuiApplication app(argc, argv);

    qmlRegisterType<ApplicationManagerWindow>("QtApplicationManager", 1, 0, "ApplicationManagerWindow");

    const QString prefix = STR(INSTALL_PATH) + QStringLiteral("apps/com.pelagicore.qtlocation/");
    const QString mainQml = prefix + QStringLiteral("Main.qml");

    copyOfflineDB(prefix);

    QQmlApplicationEngine engine;
    engine.addImportPath(STR(INSTALL_PATH) + QStringLiteral("imports/shared"));
    engine.addPluginPath(STR(INSTALL_PATH));
    engine.load(mainQml);

    return app.exec();
}
