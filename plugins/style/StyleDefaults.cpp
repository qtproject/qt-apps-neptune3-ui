/****************************************************************************
**
** Copyright (C) 2019-2020 Luxoft Sweden AB
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
#include "StyleDefaults.h"
#include <QDebug>
#include <QDir>
#include <QQuickStyle>
#include <QQmlEngine>

#define CHECK_KEY(key) \
    if (!settings.contains(key)) { \
        qCritical() << "Style: Missing key \"" key  "\" in group" << settings.group(); \
        return; \
    }

#define FETCH_COLOR(variable, key) \
    CHECK_KEY(key) \
    variable.setNamedColor(settings.value(key).toString());

#define FETCH_REAL(variable, key) \
    CHECK_KEY(key) \
    variable = settings.value(key).toReal();

StyleDefaults *StyleDefaults::m_instance = nullptr;
QQmlEngine *StyleDefaults::m_engine = nullptr;

void StyleDefaults::setEngine(QQmlEngine *e)
{
    if (!m_engine && e)
        m_engine = e;
}

StyleDefaults *StyleDefaults::instance()
{
    if (!m_instance) {
        m_instance = new StyleDefaults;
    }
    return m_instance;
}

StyleDefaults::StyleDefaults()
{
    const char *confFileName = "style.conf";

    QDir chosenStyleDir = QStringLiteral("/does-not-exist0000000000000000");

    Q_ASSERT(m_engine);
    const QString name = QQuickStyle::name();
    const auto paths = m_engine->importPathList();

    for (const auto &path : paths) {
        QDir d(path);
        if (d.cd(name)) {
            chosenStyleDir = d;
            break;
        }
    }

    if (!chosenStyleDir.exists()) {
        qCritical() << "Style: directory for the chosen style does not exist:" << chosenStyleDir.absolutePath();
        return;
    }

    m_imagePath = chosenStyleDir.absoluteFilePath(QStringLiteral("images"));

    if (!chosenStyleDir.exists(confFileName)) {
        qCritical() << "Style: Missing file" << chosenStyleDir.absoluteFilePath(confFileName);
        return;
    }

    QString filePath = chosenStyleDir.absoluteFilePath(confFileName);

    QSettings settings(filePath, QSettings::IniFormat);

    CHECK_KEY("Theme")
    m_data.theme = settings.value("Theme").toString() == QString("Light") ? StyleData::Light : StyleData::Dark;

    QStringList themes = settings.childGroups();

    if (themes.contains("Light")) {
        settings.beginGroup("Light");
        loadTheme(m_data.themes[StyleData::Light], settings);
        settings.endGroup();
    }

    if (themes.contains("Dark")) {
        settings.beginGroup("Dark");
        loadTheme(m_data.themes[StyleData::Dark], settings);
        settings.endGroup();
    }
}

void StyleDefaults::loadTheme(StyleData::ThemeData &data, QSettings &settings)
{
    FETCH_COLOR(data.accentColor, "AccentColor");
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

const StyleData::ThemeData &StyleDefaults::dataFromTheme(StyleData::Theme theme)
{
    Q_ASSERT(m_data.themes.contains(theme));
    return m_data.themes[theme];
}

bool StyleDefaults::supportsMultipleThemes() const
{
    return m_data.themes.count() > 1;
}
