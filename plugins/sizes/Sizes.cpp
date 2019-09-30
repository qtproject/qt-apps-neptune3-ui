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

#include "Sizes.h"
#include <QtQml/qqmlinfo.h>
#include <QtGui/QGuiApplication>
#include <QQmlEngine>

#include <QtQuickControls2/private/qquickstyle_p.h>



class StyleData {
public:
    StyleData()
        : scale(1.0)
    {
        compute();
    }
    StyleData(const StyleData &data)
        : scale(data.scale)
    {
        compute();
    }

    void compute() {
        //TODO correct all font sizes when spec is updated accordingly
        //for the moment only S and M are specified

        float baseSize = 28.;

        fontSizeXXS = qRound(baseSize * 0.4);
        fontSizeXS = qRound(baseSize * 0.6);
        fontSizeS = 24;
        fontSizeM = 28;
        fontSizeL = qRound(baseSize * 1.25);
        fontSizeXL = qRound(baseSize * 1.5);
        fontSizeXXL = qRound(baseSize * 1.75);
    }

    int fontSizeXXS;
    int fontSizeXS;
    int fontSizeS;
    int fontSizeM;
    int fontSizeL;
    int fontSizeXL;
    int fontSizeXXL;
    qreal scale;
};

static StyleData GlobalStyleData;

Sizes::Sizes(QObject *parent)
    : QQuickAttachedObject(parent)
    , m_data(new StyleData(GlobalStyleData))
{
    init();
}

Sizes::~Sizes()
{
}

Sizes *Sizes::qmlAttachedProperties(QObject *object)
{
    return new Sizes(object);
}

int Sizes::fontSizeXXS() const
{
    return qRound(m_data->fontSizeXXS * m_data->scale);
}

int Sizes::fontSizeXS() const
{
    return qRound(m_data->fontSizeXS * m_data->scale);
}

int Sizes::fontSizeS() const
{
    return qRound(m_data->fontSizeS * m_data->scale);
}

int Sizes::fontSizeM() const
{
    return qRound(m_data->fontSizeM * m_data->scale);
}

int Sizes::fontSizeL() const
{
    return qRound(m_data->fontSizeL * m_data->scale);
}

int Sizes::fontSizeXL() const
{
    return qRound(m_data->fontSizeXL * m_data->scale);
}

int Sizes::fontSizeXXL() const
{
    return qRound(m_data->fontSizeXXL * m_data->scale);
}

void Sizes::init()
{
    m_data.reset(new StyleData(GlobalStyleData));
    QQuickAttachedObject::init();
}

void Sizes::attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent)
{
    Q_UNUSED(oldParent)
    Sizes* neptune = qobject_cast<Sizes *>(newParent);
    if (neptune) {
        inheritStyle(*neptune->m_data);
    }
}

void Sizes::inheritStyle(const StyleData& data)
{
    m_data.reset(new StyleData(data));
    propagateStyle(data);
    m_dp = QJSValue();
    emit scaleChanged();
}

void Sizes::propagateStyle(const StyleData& data)
{
    const auto children = attachedChildren();
    for (auto *child : children) {
        Sizes* neptune = qobject_cast<Sizes *>(child);
        if (neptune)
            neptune->inheritStyle(data);
    }
}

qreal Sizes::scale() const
{
    return m_data->scale;
}

void Sizes::setScale(qreal value)
{
    if (qFuzzyCompare(value, m_data->scale))
        return;

    m_data->scale = value;
    propagateScale();
    m_dp = QJSValue();
    emit scaleChanged();
}

void Sizes::propagateScale()
{
    for (QQuickAttachedObject *child : attachedChildren()) {
        Sizes* neptune = qobject_cast<Sizes *>(child);
        if (neptune && !qFuzzyCompare(neptune->scale(), m_data->scale))
            neptune->setScale(m_data->scale);
    }
}

QJSValue Sizes::dp() const
{
    if (!m_dp.isCallable()) {
        QQmlEngine *engine = qmlEngine(parent());
        if (engine) {
            auto str = QStringLiteral("(function(value) { return Math.round(value * %1); })").arg(scale());
            m_dp = engine->evaluate(str);
        }
    }
    return m_dp;
}
