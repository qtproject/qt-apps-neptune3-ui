/****************************************************************************
**
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
#include "BasicStyleDefaults.h"
#include <QDebug>
#include <QDir>
#include <QQuickStyle>

#define CHECK_KEY(key) \
    if (!settings.contains(key)) { \
        qCritical() << "BasicStyle: Missing key \"" key  "\" in group" << settings.group(); \
        return; \
    }

#define FETCH_COLOR(variable, key) \
    CHECK_KEY(key) \
    variable.setNamedColor(settings.value(key).toString());

#define FETCH_REAL(variable, key) \
    CHECK_KEY(key) \
    variable = settings.value(key).toReal();

BasicStyleDefaults *BasicStyleDefaults::m_instance = nullptr;

BasicStyleDefaults *BasicStyleDefaults::instance()
{
    if (!m_instance) {
        m_instance = new BasicStyleDefaults;
    }
    return m_instance;
}

BasicStyleDefaults::BasicStyleDefaults()
{
    QDir chosenStyleDir(QDir(QQuickStyle::path()).absoluteFilePath(QQuickStyle::name()));

    if (!chosenStyleDir.exists()) {
        qCritical() << "BasicStyle: directory for the chosen style does not exist:" << chosenStyleDir.absolutePath();
        return;
    }

    if (!chosenStyleDir.exists("basicstyle.conf")) {
        qCritical() << "BasicStyle: Missing file" << chosenStyleDir.absoluteFilePath("basicstyle.conf");
        return;
    }

    QString filePath = chosenStyleDir.absoluteFilePath("basicstyle.conf");

    QSettings settings(filePath, QSettings::IniFormat);

    CHECK_KEY("Theme")
    m_data.theme = settings.value("Theme").toString() == QString("Light") ? BasicStyleData::Light : BasicStyleData::Dark;

    FETCH_COLOR(m_data.accentColor, "AccentColor")

    settings.beginGroup("Light");
    loadTheme(m_data.lightTheme, settings);
    settings.endGroup();

    settings.beginGroup("Dark");
    loadTheme(m_data.darkTheme, settings);
    settings.endGroup();
}

void BasicStyleDefaults::loadTheme(BasicStyleData::ThemeData &data, QSettings &settings)
{
    FETCH_COLOR(data.backgroundColor, "BackgroundColor");
    FETCH_COLOR(data.buttonColor, "ButtonColor");
    FETCH_COLOR(data.highlightedButtonColor, "HighlightedButtonColor");
    FETCH_COLOR(data.mainColor, "MainColor");
    FETCH_COLOR(data.offMainColor, "OffMainColor");
    FETCH_COLOR(data.accentDetailColor, "AccentDetailColor");
    FETCH_COLOR(data.contrastColor, "ContrastColor");
    FETCH_COLOR(data.clusterMarksColor, "ClusterMarksColor");

    FETCH_REAL(data.opacityHigh, "OpacityHigh");
    FETCH_REAL(data.opacityMedium, "OpacityMedium");
    FETCH_REAL(data.opacityLow, "OpacityLow");
    FETCH_REAL(data.defaultDisabledOpacity, "DefaultDisabledOpacity");

    CHECK_KEY("FontFamily")
    data.fontFamily = settings.value("FontFamily").toString();
}

const BasicStyleData::ThemeData BasicStyleDefaults::dataFromTheme(BasicStyleData::Theme theme) const
{
    if (theme == BasicStyleData::Light)
        return m_data.lightTheme;
    else
        return m_data.darkTheme;
}
