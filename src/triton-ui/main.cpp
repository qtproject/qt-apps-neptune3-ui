/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

#include <QtAppManCommon/global.h>
#include <QtAppManCommon/logging.h>
#include <QtAppManMain/main.h>
#include <QtAppManMain/defaultconfiguration.h>
#include <QtAppManPackage/package.h>
#include <QtAppManInstaller/sudo.h>
#include <QGuiApplication>
#include <QIcon>
#include <QTranslator>
#include <QLibraryInfo>
#include <QFileInfo>

#include <QDebug>

#include "ApplicationInfo.h"
#include "ApplicationModel.h"

QT_USE_NAMESPACE_AM

// code to transform a macro into a string literal
#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)

void startRemoteSettingsServer(const QString &argv) {
    QFileInfo fi(argv);
    QProcess *serverProcess = new QProcess(qApp);
    QObject::connect(serverProcess, &QProcess::stateChanged, [serverProcess] (QProcess::ProcessState state) {
        if (state == QProcess::Running) {
            qCInfo(LogSystem) << "Attempted automatic start of RemoteSettingsServer, pid:" << serverProcess->processId();
        }
    });
    QObject::connect(qApp, &QCoreApplication::aboutToQuit, [serverProcess] () {
        serverProcess->terminate();
    });
    serverProcess->start(QStringLiteral("%1/RemoteSettingsServer").arg(fi.canonicalPath()), QProcess::ReadOnly);
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#if defined(Q_OS_UNIX) && defined(AM_MULTI_PROCESS)
    // set a reasonable default for OSes/distros that do not set this by default
    setenv("XDG_RUNTIME_DIR", "/tmp", 0);
#endif

    QCoreApplication::setApplicationName(qSL("Triton UI"));
    QCoreApplication::setOrganizationName(qSL("Pelagicore AG"));
    QCoreApplication::setOrganizationDomain(qSL("pelagicore.com"));
    QCoreApplication::setApplicationVersion(TRITON_VERSION);

    Logging::initialize();

    Package::ensureCorrectLocale();

    QString error;
    if (Q_UNLIKELY(!forkSudoServer(DropPrivilegesPermanently, &error))) {
        qCCritical(LogSystem) << "ERROR:" << qPrintable(error);
        return 2;
    }

    try {
        setenv("QT_IM_MODULE", "qtvirtualkeyboard", 1);
        // this is needed for both WebEngine and Wayland Multi-screen rendering
        QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
#if !defined(QT_NO_SESSIONMANAGER)
        QGuiApplication::setFallbackSessionManagementEnabled(false);
#endif

        Main a(argc, argv);

        // start the server; the server itself will ensure one instance only
        startRemoteSettingsServer(QFile::decodeName(argv[0]));

        // load the Qt translations
        QTranslator qtTranslator;
        if (qtTranslator.load(QLocale(), qSL("qt_"), QString(), QLibraryInfo::location(QLibraryInfo::TranslationsPath))) {
            a.installTranslator(&qtTranslator);
        }

        QIcon::setThemeName("triton");
        {
            QStringList searchPaths = QIcon::themeSearchPaths();
            searchPaths.prepend(STR(TRITON_ICONS_PATH));
            QIcon::setThemeSearchPaths(searchPaths);
        }

        qmlRegisterUncreatableType<ApplicationInfo>("models.application", 1, 0, "ApplicationInfo", "You canot create ApplicationInfo instances from QML");
        qRegisterMetaType<ApplicationInfo*>();
        qRegisterMetaType<const QObject*>();
        // ApplicatinoModel uses QtAppMan headers and QtAplicationManager is distributed as a static library.
        // So loading it from both the binary executable and from a plugin shared lib would cause two AppMan
        // instances to reside in memory.
        // That's why ApplicationModel can't be put in a QML plugin right now.
        // TODO: Try to have ApplicationModel working without accessing QtAppMan headers
        qmlRegisterType<ApplicationModel>("models.application", 1, 0, "ApplicationModel");

        DefaultConfiguration cfg(QStringList(qSL("am-config.yaml")), QString());
        cfg.parse();
        a.setup(&cfg);
        a.loadQml(cfg.loadDummyData());
        a.showWindow(cfg.fullscreen() && !cfg.noFullscreen());

        return MainBase::exec();
    } catch (const std::exception &e) {
        qCCritical(LogSystem) << "ERROR:" << e.what();
        return 2;
    }
}
