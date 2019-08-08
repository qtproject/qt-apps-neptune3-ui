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
#pragma once

#include "StyleData.h"

#include <QtQuickControls2/private/qquickattachedobject_p.h>
#include <QJSValue>

class Style : public QQuickAttachedObject
{
    Q_OBJECT
    Q_PROPERTY(Theme theme READ theme WRITE setTheme NOTIFY themeChanged FINAL)
    Q_PROPERTY(bool supportsMultipleThemes READ supportsMultipleThemes CONSTANT FINAL)

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

    Q_PROPERTY(QString name READ name CONSTANT FINAL)

    /*
        Returns the file path for the given image name in the current style and theme

        Do not specify any file sufix. Ie, call Style.image("foobar"), not Style.image("foobar.png")
     */
    // This is a property instead of a Q_INVOKABLE so that it gets reevaluated by QML bindings when
    // its NOTIFY signal is emitted (in that case, when the theme changes). We need that as its results
    // are theme-dependent.
    Q_PROPERTY(QJSValue image READ image NOTIFY themeChanged)


public:

    // Not really public API. This is a helper method for the image property (which is a javascript Function,
    // ie. a callable object). Q_INVOKABLE as it's called from the javascript side (the QJSValue Function in
    // the image property)
    Q_INVOKABLE QString imageHelper(const QString &value);

    enum Theme { Light=StyleData::Light, Dark=StyleData::Dark };
    Q_ENUM(Theme)

    explicit Style(QObject *parent = nullptr);
    virtual ~Style();

    static Style *qmlAttachedProperties(QObject *object);

    Theme theme() const { return (Theme) m_theme; }
    void setTheme(Theme);

    bool supportsMultipleThemes() const;

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

    QString name() const;

    QJSValue image();

protected:
    void init();
    void attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent) override;

signals:
    void accentColorChanged();
    void themeChanged();

private:
    void inheritStyle(const Style& inheritedStyle);
    void propagateAccentColor();
    void propagateTheme();

    enum StyleData::Theme m_theme;
    QColor m_accentColor;

    mutable QJSValue m_image;
};

QML_DECLARE_TYPEINFO(Style, QML_HAS_ATTACHED_PROPERTIES)
