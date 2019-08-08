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

#include "translation.h"
#include <QGuiApplication>
#include <QtQml>
#include <QScreen>
#include <QDebug>
#include <QDirIterator>

Translation::Translation(QObject *parent)
    : QObject(parent)
{
}

void Translation::setPath(const QUrl &languageFilePath)
{
    m_languageFilePath = languageFilePath;

    // find the available translations
    m_availableTranslations.clear();
    QDirIterator it(m_languageFilePath.toLocalFile(), {QStringLiteral("*.qm")}, QDir::Files|QDir::Readable);
    while (it.hasNext()) {
        it.next();
        m_availableTranslations.append(it.fileInfo().baseName());
    }
    emit availableTranslationsChanged();
    emit pathChanged();
}

QUrl Translation::path()
{
    return m_languageFilePath;
}

void Translation::setLanguageLocale(const QString &languageLocale)
{
    if (m_languageLocale != languageLocale) {
        if ( loadTranslationFile(languageLocale) ) {
            m_languageLocale = languageLocale;

            emit languageLocaleChanged();
        }
    }
}

QString Translation::languageLocale() const
{
    return m_languageLocale;
}

QStringList Translation::availableTranslations() const
{
    return m_availableTranslations;
}

QString Translation::formatTime(const QDateTime &dt, bool twentyFourH) const
{
    return QLocale(m_languageLocale).toString(dt, twentyFourH ? "hh:mm" : "hh:mm a");
}

bool Translation::loadTranslationFile(const QString &langLocale)
{
    QString fileToLoad(m_languageFilePath.toLocalFile());
    fileToLoad += langLocale + ".qm";

    const bool loaded = m_translator.load(fileToLoad);
    if (loaded || m_translator.isEmpty()) { // en_US is usually empty but we still want to switch to it
        qApp->installTranslator(&m_translator);

        QLocale::setDefault(QLocale(langLocale));

        auto ctx = QQmlEngine::contextForObject(this);
        if (ctx)
            ctx->engine()->retranslate();

        return true;
    }

    qWarning() << "Failed to load translation file" << langLocale;

    return false;
}
