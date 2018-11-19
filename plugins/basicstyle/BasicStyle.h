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
#pragma once

#include "BasicStyleData.h"

#include <QtQuickControls2/private/qquickattachedobject_p.h>

class BasicStyle : public QQuickAttachedObject
{
    Q_OBJECT
    Q_PROPERTY(Theme theme READ theme WRITE setTheme NOTIFY themeChanged FINAL)

    // naming scheme use by other qt control styles
    // TODO: update controls to use colors from the design spec group or update the specs if needed
    Q_PROPERTY(QColor backgroundColor READ backgroundColor NOTIFY themeChanged FINAL)
    Q_PROPERTY(QColor buttonColor READ buttonColor NOTIFY themeChanged FINAL)
    Q_PROPERTY(QColor highlightedButtonColor READ highlightedButtonColor NOTIFY themeChanged FINAL)

    // naming scheme used in the design specs
    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged FINAL)
    Q_PROPERTY(QColor mainColor READ mainColor NOTIFY themeChanged FINAL)
    Q_PROPERTY(QColor offMainColor READ offMainColor NOTIFY themeChanged FINAL)
    Q_PROPERTY(QColor accentDetailColor READ accentDetailColor NOTIFY themeChanged FINAL)
    Q_PROPERTY(QColor contrastColor READ contrastColor NOTIFY themeChanged FINAL)
    Q_PROPERTY(QColor clusterMarksColor READ clusterMarksColor NOTIFY themeChanged FINAL)

    Q_PROPERTY(qreal opacityLow READ opacityLow NOTIFY themeChanged FINAL)
    Q_PROPERTY(qreal opacityMedium READ opacityMedium NOTIFY themeChanged FINAL)
    Q_PROPERTY(qreal opacityHigh READ opacityHigh NOTIFY themeChanged FINAL)
    Q_PROPERTY(qreal defaultDisabledOpacity READ defaultDisabledOpacity NOTIFY themeChanged FINAL)

    Q_PROPERTY(QString fontFamily READ fontFamily NOTIFY themeChanged FINAL)

public:
    enum Theme { Light=BasicStyleData::Light, Dark=BasicStyleData::Dark };
    Q_ENUM(Theme)

    explicit BasicStyle(QObject *parent = nullptr);
    virtual ~BasicStyle();

    static BasicStyle *qmlAttachedProperties(QObject *object);

    Theme theme() const { return (Theme) m_theme; }
    void setTheme(Theme);

    QColor accentColor() const { return m_accentColor; }
    void setAccentColor(const QColor &accent);

    QColor backgroundColor() const;
    QColor buttonColor() const;
    QColor highlightedButtonColor() const;
    QColor mainColor() const;
    QColor offMainColor() const;
    QColor accentDetailColor() const;
    QColor contrastColor() const;
    QColor clusterMarksColor() const;

    qreal opacityHigh() const;
    qreal opacityMedium() const;
    qreal opacityLow() const;
    qreal defaultDisabledOpacity() const;

    QString fontFamily() const;

protected:
    void init();
    void attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent) override;

signals:
    void accentColorChanged();
    void themeChanged();

private:
    void inheritStyle(const BasicStyle& inheritedStyle);
    void propagateAccentColor();
    void propagateTheme();

    enum BasicStyleData::Theme m_theme;
    QColor m_accentColor;
};

QML_DECLARE_TYPEINFO(BasicStyle, QML_HAS_ATTACHED_PROPERTIES)
