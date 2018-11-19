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

#include "BasicStyle.h"
#include "BasicStyleDefaults.h"

BasicStyle::BasicStyle(QObject *parent)
    : QQuickAttachedObject(parent)
{
    init();
}

BasicStyle::~BasicStyle()
{
}

BasicStyle *BasicStyle::qmlAttachedProperties(QObject *object)
{
    return new BasicStyle(object);
}

void BasicStyle::init()
{
    m_theme = BasicStyleDefaults::instance()->data().theme;
    m_accentColor = BasicStyleDefaults::instance()->data().accentColor;

    QQuickAttachedObject::init();
}

void BasicStyle::attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent)
{
    Q_UNUSED(oldParent);
    BasicStyle* parentStyle = qobject_cast<BasicStyle *>(newParent);
    if (parentStyle)
        inheritStyle(*parentStyle);
}

void BasicStyle::inheritStyle(const BasicStyle& inheritedStyle)
{
    if (m_accentColor != inheritedStyle.m_accentColor) {
        m_accentColor = inheritedStyle.m_accentColor;
        emit accentColorChanged();
    }

    const auto children = attachedChildren();
    for (auto *child : children) {
        BasicStyle* basicStyle = qobject_cast<BasicStyle *>(child);
        if (basicStyle)
            basicStyle->inheritStyle(inheritedStyle);
    }
}

void BasicStyle::setAccentColor(const QColor &accent)
{
    if (m_accentColor == accent || !accent.isValid())
        return;

    m_accentColor = accent;
    propagateAccentColor();
    emit accentColorChanged();
}

void BasicStyle::setTheme(BasicStyle::Theme value)
{
    if (value == (Theme)m_theme)
        return;

    m_theme = (BasicStyleData::Theme)value;
    propagateTheme();
    emit themeChanged();
}

void BasicStyle::propagateAccentColor()
{
    for (QQuickAttachedObject *child : attachedChildren()) {
        BasicStyle* basicStyle = qobject_cast<BasicStyle *>(child);
        if (basicStyle)
            basicStyle->setAccentColor(m_accentColor);
    }
}

void BasicStyle::propagateTheme()
{
    for (QQuickAttachedObject *child : attachedChildren()) {
        BasicStyle* basicStyle = qobject_cast<BasicStyle *>(child);
        if (basicStyle)
            basicStyle->setTheme((Theme)m_theme);
    }
}

qreal BasicStyle::opacityHigh() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).opacityHigh;
}

qreal BasicStyle::opacityMedium() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).opacityMedium;
}

qreal BasicStyle::opacityLow() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).opacityLow;
}

qreal BasicStyle::defaultDisabledOpacity() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).defaultDisabledOpacity;
}

QColor BasicStyle::backgroundColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).backgroundColor;
}

QColor BasicStyle::buttonColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).buttonColor;
}

QColor BasicStyle::highlightedButtonColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).highlightedButtonColor;
}

QColor BasicStyle::mainColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).mainColor;
}

QColor BasicStyle::offMainColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).offMainColor;
}

QColor BasicStyle::accentDetailColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).accentDetailColor;
}

QColor BasicStyle::contrastColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).contrastColor;
}

QColor BasicStyle::clusterMarksColor() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).clusterMarksColor;
}

QString BasicStyle::fontFamily() const
{
    return BasicStyleDefaults::instance()->dataFromTheme(m_theme).fontFamily;
}
