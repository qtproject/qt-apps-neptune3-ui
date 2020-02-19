/****************************************************************************
**
** Copyright (C) 2019-2020 Luxoft Sweden AB
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

#include <QtGlobal>
#include <QtGui/QGuiApplication>
#include <QtGui/QIcon>
#include <QtGui/QOpenGLContext>
#include <QtQml/QQmlApplicationEngine>
#include <QtCore/QLoggingCategory>
#include <QtCore/QDir>
#include <QtCore/QString>
#include <QtCore/QCommandLineParser>

#ifdef STUDIO3D_RUNTIME_INSTALLED
    #include <qstudio3dglobal.h>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setApplicationName(QStringLiteral("Neptune Cluster"));
    QCoreApplication::setOrganizationName(QStringLiteral("Luxoft Sweden AB"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("luxoft.com"));
    QCoreApplication::setApplicationVersion("0.1");
    QGuiApplication app(argc, argv);

    // @todo: add -c config file option and config file for it (json, xml, etc)
    QCommandLineParser cmdParser;
    cmdParser.setApplicationDescription(
            "Neptune Cluster\n\n"
            "Logging is turned off by default, use QT_LOGGING_RULES to change this\n");
    cmdParser.addHelpOption();
    cmdParser.process(app);

    QLoggingCategory::setFilterRules("*=false");

    if (!qEnvironmentVariableIsSet("QT_QUICK_CONTROLS_STYLE_PATH")) {
        qputenv("QT_QUICK_CONTROLS_STYLE_PATH"
                , (QCoreApplication::applicationDirPath() + QStringLiteral("/styles")).toLocal8Bit());
    }

    if (!qEnvironmentVariableIsSet("QT_QUICK_CONTROLS_CONF")) {
        qputenv("QT_QUICK_CONTROLS_CONF", (QCoreApplication::applicationDirPath()
                + QStringLiteral("/styles/neptune/style.conf")).toLocal8Bit());
    }

    if (!qEnvironmentVariableIsSet("QT_QUICK_CONTROLS_ICON_PATH")) {
        qputenv("QT_QUICK_CONTROLS_ICON_PATH", (QCoreApplication::applicationDirPath()
                + QStringLiteral("/imports_shared/assets/icons")).toLocal8Bit());
    }

    if (!qEnvironmentVariableIsSet("SERVER_CONF_PATH")) {
        qputenv("SERVER_CONF_PATH", (QCoreApplication::applicationDirPath()
                + QStringLiteral("/server.conf")).toLocal8Bit());
    }

    if (!qEnvironmentVariableIsSet("QT_STYLE_OVERRIDE")) {
        qputenv("QT_STYLE_OVERRIDE", QStringLiteral("neptune").toLocal8Bit());
    }

#ifdef STUDIO3D_RUNTIME_INSTALLED
    QSurfaceFormat::setDefaultFormat(Q3DS::surfaceFormat());
#endif

    QQmlApplicationEngine engine;
    engine.addImportPath(QDir::currentPath()+QStringLiteral("/imports_shared/"));
    engine.load(QStringLiteral("neptune-cluster/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
