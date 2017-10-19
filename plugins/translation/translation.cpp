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

#include "translation.h"
#include <QGuiApplication>
#include <QtQml>
#include <QScreen>
#include <QDebug>

Translation::Translation(QObject *parent)
    : QObject(parent)
{
}

void Translation::setPath(const QUrl &languageFilePath)
{
    m_languageFilePath = languageFilePath.toLocalFile();
}

void Translation::setLanguageLocale(const QString &languageLocale)
{
    if (m_languageLocale != languageLocale) {
        if ( loadTranslationFile(languageLocale) ) {
            m_languageLocale = languageLocale;

            emit languageLocaleChanged();
            emit languageChanged();
        }
    }
}

QString Translation::languageLocale() const
{
    return m_languageLocale;
}

bool Translation::loadTranslationFile(const QString &langLocale)
{
    QString fileToLoad(m_languageFilePath);
    fileToLoad += langLocale + ".qm";

    if ( m_translator.load(fileToLoad) ) {
        qApp->installTranslator(&m_translator);

        QEvent ev(QEvent::LanguageChange);
        qApp->sendEvent(QQmlEngine::contextForObject(this)->engine(), &ev);

        return true;
    }

    qWarning() << "Failed to load translation file";

    return false;
}
