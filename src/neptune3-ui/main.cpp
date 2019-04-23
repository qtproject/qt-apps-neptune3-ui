/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

#include <QtAppManCommon/global.h>
#include <QtAppManCommon/logging.h>
#include <QtAppManCommonVersion>
#include <QtIviCore/QtIviCoreVersion>
#include <QtAppManMain/main.h>
#include <QtAppManMain/defaultconfiguration.h>
#include <QtAppManPackage/package.h>
#include <QtAppManInstaller/sudo.h>
#include <QtAppManWindow/touchemulation.h>
#include <QGuiApplication>
#include <QTranslator>
#include <QLibraryInfo>
#include <QFileInfo>
#include <QDir>
#include <QProcess>
#include <QTouchDevice>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QDebug>

#ifdef Q_OS_ANDROID
# include "urlinterceptor.h"
#endif

QT_USE_NAMESPACE_AM

// code to transform a macro into a string literal
#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)

void startExtraProcess(const QString &name) {
#if QT_CONFIG(process)
    QProcess *serverProcess = new QProcess(qApp);
    QObject::connect(serverProcess, &QProcess::stateChanged, [name, serverProcess] (QProcess::ProcessState state) {
        if (state == QProcess::Running) {
            qCInfo(LogSystem) << "Attempted automatic start of " << name << ", pid:" << serverProcess->processId();
        }
    });
    QObject::connect(qApp, &QCoreApplication::aboutToQuit, [serverProcess] () {
        serverProcess->terminate();
    });
    serverProcess->start(name, QProcess::ReadOnly);
#endif
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef Q_OS_ANDROID
    qputenv("QML_DISABLE_DISK_CACHE", "1");
#endif

    QCoreApplication::setApplicationName(qSL("Neptune UI"));
    QCoreApplication::setOrganizationName(qSL("Luxoft Sweden AB"));
    QCoreApplication::setOrganizationDomain(qSL("luxoft.com"));
    QCoreApplication::setApplicationVersion(STR(NEPTUNE_VERSION));

    Logging::initialize();

    Package::ensureCorrectLocale();

    try {
        QStringList deploymentWarnings;
        Sudo::forkServer(Sudo::DropPrivilegesPermanently, &deploymentWarnings);

        qputenv("QTIVIMEDIA_SIMULATOR_DATABASE", QFile::encodeName(QDir::homePath() + "/media.db"));
        qputenv("QT_IM_MODULE", "qtvirtualkeyboard");

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
        Q_UNUSED(argc)
        char arg1[] = "--recreate-database";
        char *_argv[] = { argv[0], arg1, nullptr };
        int _argc = 2;
        Main a(_argc, &_argv[0]);
#else
        Main a(argc, argv);

        // start the server; the server itself will ensure one instance only
        startExtraProcess(QLibraryInfo::location(QLibraryInfo::BinariesPath) + "/vehiclefunctions-simulation-server");
        startExtraProcess(QCoreApplication::applicationDirPath() + "/drivedata-server");
        startExtraProcess(QCoreApplication::applicationDirPath() + "/dataprovider-server");
#endif

        // load the Qt translations
        QTranslator qtTranslator;
        if (qtTranslator.load(QLocale(), qSL("qt_"), QString(), QLibraryInfo::location(QLibraryInfo::TranslationsPath))) {
            a.installTranslator(&qtTranslator);
        }

#ifdef Q_OS_ANDROID
        DefaultConfiguration cfg(QStringList({ qSL("assets:/am-config-neptune.yaml"), qSL("assets:/am-config-android.yaml") }), QString());
#else
        DefaultConfiguration cfg(QStringList(qSL("am-config-neptune.yaml")), QString());
#endif

        cfg.parse();
        a.setup(&cfg, deploymentWarnings);

#ifdef USE_QT_SAFE_RENDERER
        //Set env variables for Qt Safe Renderer for sending heartbeats
        //env variables are used to start TCP client to connect to "safe ui" part
        //qsrEnabled also switches loading of Safe Telltales in Cluster View
        bool    qsrEnabled = cfg.rawSystemProperties()["public"].toMap()["qsrEnabled"].toBool();
        if (qsrEnabled)
        {
            QString qsrIp   = cfg.rawSystemProperties()["public"].toMap()["qsrServerAddress"].toString();
            QString qsrPort = cfg.rawSystemProperties()["public"].toMap()["qsrServerPort"].toString();

            if (!qsrPort.isEmpty() && !qsrIp.isEmpty()) {
                qputenv("QT_SAFERENDER_IPADDRESS", qsrIp.toLocal8Bit());
                qputenv("QT_SAFERENDER_PORT", qsrPort.toLocal8Bit());
            }
        }
#endif

        // setup touch emulation manually at runtime, if it's available _and_ there are no native touch devices
        if (TouchEmulation::isSupported() && QTouchDevice::devices().isEmpty())
            TouchEmulation::createInstance();

#ifdef Q_OS_ANDROID
        a.qmlEngine()->setUrlInterceptor(new UrlInterceptor);
#endif

        a.loadQml(cfg.loadDummyData());
        a.showWindow(cfg.fullscreen() && !cfg.noFullscreen());

        auto ctx = a.qmlEngine()->rootContext();
        ctx->setContextProperty("neptuneInfo", STR(NEPTUNE_INFO));
        ctx->setContextProperty("qtamVersion", QTAPPMANCOMMON_VERSION_STR);
        ctx->setContextProperty("qtiviVersion", QTIVICORE_VERSION_STR);

        return MainBase::exec();
    } catch (const std::exception &e) {
        qCCritical(LogSystem) << "ERROR:" << e.what();
        return 2;
    }
}
