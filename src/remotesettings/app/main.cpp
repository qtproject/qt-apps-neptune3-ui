/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QtCore/QCommandLineParser>
#include <QtInterfaceFramework/QtInterfaceFrameworkVersion>
#include "client.h"

// code to transform a macro into a string literal
#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName(QStringLiteral("Neptune Companion"));
    QCoreApplication::setOrganizationName(QStringLiteral("Luxoft Sweden AB"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("luxoft.com"));
    QCoreApplication::setApplicationVersion(STR(NEPTUNE_COMPANION_APP_VERSION));
    QGuiApplication app(argc, argv);

    QCommandLineParser cmdParser;
    cmdParser.setApplicationDescription(
                "Neptune Companion\n\n"
                "Logging is turned off by default, to control log output please check command line "
                "options or Qt Help for QT_LOGGING_RULES environment variable.\n");
    cmdParser.addHelpOption();
    cmdParser.addVersionOption();
    const QCommandLineOption enableDefaultLoggingOption("verbose",
                                                        "Enables default Qt logging filter.");
    cmdParser.addOption(enableDefaultLoggingOption);
    cmdParser.process(app);
    if (!cmdParser.isSet(enableDefaultLoggingOption)) {
        QLoggingCategory::setFilterRules("*=false");
    }

    Client client;

    QQmlApplicationEngine engine;
    engine.addImportPath(QDir::currentPath()+QStringLiteral("/imports_shared/"));
    engine.rootContext()->setContextProperty(QStringLiteral("client"), &client);
    engine.rootContext()->setContextProperty("neptuneGitRevision", STR(NEPTUNE_GIT_REVISION));
    engine.rootContext()->setContextProperty("qtifVersion", QTINTERFACEFRAMEWORK_VERSION_STR);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
