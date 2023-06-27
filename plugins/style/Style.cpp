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

#include "Style.h"
#include "StyleDefaults.h"

#include <QDir>
#include <QFileInfo>
#include <QQmlEngine>
#include <QQuickStyle>
#include <QtQml/qqmlinfo.h>

Style::Style(QObject *parent)
    : QQuickAttachedPropertyPropagator(parent)
{
    initialize();
}

Style::~Style()
{
}

Style *Style::qmlAttachedProperties(QObject *object)
{
    StyleDefaults::setEngine(qmlEngine(object));
    return new Style(object);
}

void Style::initialize()
{
    m_theme = StyleDefaults::instance()->data().theme;
    m_accentColor = StyleDefaults::instance()->dataFromTheme(m_theme).accentColor;

    QQuickAttachedPropertyPropagator::initialize();
}

void Style::attachedParentChange(QQuickAttachedPropertyPropagator *newParent, QQuickAttachedPropertyPropagator *oldParent)
{
    Q_UNUSED(oldParent);
    Style* parentStyle = qobject_cast<Style *>(newParent);
    if (parentStyle)
        inheritStyle(*parentStyle);
}

void Style::inheritStyle(const Style& inheritedStyle)
{
    if (m_accentColor != inheritedStyle.m_accentColor) {
        m_accentColor = inheritedStyle.m_accentColor;
        emit accentColorChanged();
    }

    if (m_theme != inheritedStyle.m_theme) {
        m_theme = inheritedStyle.m_theme;
        m_image = QJSValue();
        emit themeChanged();
    }

    const auto children = attachedChildren();
    for (auto *child : children) {
        Style* basicStyle = qobject_cast<Style *>(child);
        if (basicStyle)
            basicStyle->inheritStyle(inheritedStyle);
    }
}

void Style::setAccentColor(const QColor &accent)
{
    if (m_accentColor == accent || !accent.isValid())
        return;

    m_accentColor = accent;
    propagateAccentColor();
    emit accentColorChanged();
}

void Style::setTheme(Style::Theme value)
{
    if (value == static_cast<Theme>(m_theme))
        return;

    if (!supportsMultipleThemes()) {
        qmlWarning(this) << "The \"" << name() << "\" style does not support multiple themes.";
        return;
    }

    m_theme = static_cast<StyleData::Theme>(value);
    m_image = QJSValue();
    propagateTheme();
    emit themeChanged();
}

bool Style::supportsMultipleThemes() const
{
    return StyleDefaults::instance()->supportsMultipleThemes();
}

void Style::propagateAccentColor()
{
    for (QQuickAttachedPropertyPropagator *child : attachedChildren()) {
        Style* basicStyle = qobject_cast<Style *>(child);
        if (basicStyle)
            basicStyle->setAccentColor(m_accentColor);
    }
}

void Style::propagateTheme()
{
    for (QQuickAttachedPropertyPropagator *child : attachedChildren()) {
        Style* basicStyle = qobject_cast<Style *>(child);
        if (basicStyle)
            basicStyle->setTheme(static_cast<Theme>(m_theme));
    }
}

qreal Style::opacityHigh() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).opacityHigh;
}

qreal Style::opacityMedium() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).opacityMedium;
}

qreal Style::opacityLow() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).opacityLow;
}

qreal Style::defaultDisabledOpacity() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).defaultDisabledOpacity;
}

QColor Style::backgroundColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).backgroundColor;
}

QColor Style::buttonColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).buttonColor;
}

QColor Style::highlightedButtonColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).highlightedButtonColor;
}

QColor Style::mainColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).mainColor;
}

QColor Style::offMainColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).offMainColor;
}

QColor Style::accentDetailColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).accentDetailColor;
}

QColor Style::contrastColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).contrastColor;
}

QColor Style::clusterMarksColor() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).clusterMarksColor;
}

QString Style::fontFamily() const
{
    return StyleDefaults::instance()->dataFromTheme(m_theme).fontFamily;
}

QString Style::name() const
{
    return QQuickStyle::name();
}

QJSValue Style::image()
{
    if (!m_image.isCallable()) {
        QQmlEngine *engine = qmlEngine(parent());
        if (engine) {
            auto str = QStringLiteral("(function(value) { return this.imageHelper(value); })");
            m_image = engine->evaluate(str);

            // Make the "this" of that javascript Function be the attached property
            m_image.property("bind").call({engine->newQObject(this)});
        }
    }
    return m_image;
}

QString Style::imageHelper(const QString &value)
{
    QString result = StyleDefaults::instance()->imagePath() + QDir::separator() + value;

    if (m_theme == StyleData::Dark) {
        QString darkResult = result;
        darkResult.append("-dark.png");
        if (QFileInfo::exists(darkResult))
            return QUrl::fromLocalFile(darkResult).toString();
    }

    result.append(".png");
    return QUrl::fromLocalFile(result).toString();
}
