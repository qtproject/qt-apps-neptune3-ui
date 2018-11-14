/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
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

#ifndef NEPTUNESTYLE_H
#define NEPTUNESTYLE_H

#include <QtGui/QColor>
#include <QtCore/QSharedPointer>
#include <QtCore/QScopedPointer>
#include <QJSValue>

QT_FORWARD_DECLARE_CLASS(QSettings)

class StyleData;

#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
#include <QtQuickControls2/private/qquickattachedobject_p.h>

class NeptuneStyle : public QQuickAttachedObject
#else
#include <QtQuickControls2/private/qquickstyleattached_p.h>

class NeptuneStyle : public QQuickStyleAttached
#endif
{
    Q_OBJECT
    Q_PROPERTY(Theme theme READ theme WRITE setTheme NOTIFY themeChanged FINAL)

    // naming scheme use by other qt control styles
    // TODO: update controls to use colors from the design spec group or update the specs if needed
    Q_PROPERTY(QColor backgroundColor READ backgroundColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor buttonColor READ buttonColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor highlightedButtonColor READ highlightedButtonColor NOTIFY neptuneStyleChanged FINAL)

    // naming scheme used in the design specs
    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged FINAL)
    Q_PROPERTY(QColor mainColor READ mainColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor offMainColor READ offMainColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor accentDetailColor READ accentDetailColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor contrastColor READ contrastColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor clusterMarksColor READ clusterMarksColor NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(qreal opacityLow READ opacityLow NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal opacityMedium READ opacityMedium NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal opacityHigh READ opacityHigh NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal defaultDisabledOpacity READ defaultDisabledOpacity NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(qreal primaryTextLetterSpacing READ primaryTextLetterSpacing NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal secondaryTextLetterSpacing READ secondaryTextLetterSpacing NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(QString fontFamily READ fontFamily NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(QString backgroundImage READ backgroundImage NOTIFY neptuneStyleChanged)

public:
    explicit NeptuneStyle(QObject *parent = nullptr);
    virtual ~NeptuneStyle();

    static NeptuneStyle *qmlAttachedProperties(QObject *object);

    enum Theme { Light, Dark };
    Q_ENUM(Theme)

    enum SystemColor {
        BackgroundColor,
        ButtonColor,
        HighlightedButtonColor,
        AccentColor,
        MainColor,
        OffMainColor,
        AccentDetailColor,
        ContrastColor,
        ClusterMarksColor
    };
    Q_ENUM(SystemColor)

    QColor systemColor(SystemColor role) const;
    QColor backgroundColor() const { return systemColor(BackgroundColor); }
    QColor buttonColor() const { return systemColor(ButtonColor); }
    QColor highlightedButtonColor() const { return systemColor(HighlightedButtonColor); }

    QColor accentColor() const;
    void setAccentColor(const QColor &accent);
    void propagateAccentColor();

    QColor mainColor() const;
    QColor offMainColor() const;
    QColor accentDetailColor() const;
    QColor contrastColor() const;
    QColor clusterMarksColor() const;

    int fontSizeXXS() const;
    int fontSizeXS() const;
    int fontSizeS() const;
    int fontSizeM() const;
    int fontSizeL() const;
    int fontSizeXL() const;
    int fontSizeXXL() const;

    qreal opacityHigh() const;
    qreal opacityMedium() const;
    qreal opacityLow() const;
    qreal defaultDisabledOpacity() const;

    qreal primaryTextLetterSpacing() const;
    qreal secondaryTextLetterSpacing() const;

    Q_INVOKABLE QColor lighter25(const QColor& color);
    Q_INVOKABLE QColor lighter50(const QColor& color);
    Q_INVOKABLE QColor lighter75(const QColor& color);
    Q_INVOKABLE QColor darker25(const QColor& color);
    Q_INVOKABLE QColor darker50(const QColor& color);
    Q_INVOKABLE QColor darker75(const QColor& color);

    QString backgroundImage() const;

    QString fontFamily() const;

    Theme theme() const;
    void setTheme(Theme);
    void inheritTheme(Theme theme);
    void propagateTheme();

protected:
    void init();
signals:
    void accentColorChanged();
    void neptuneStyleChanged();
    void themeChanged();

private:
    QScopedPointer<StyleData> m_data;
    QColor m_accentColor;

protected:
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    void attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent) override;
#else
    void parentStyleChange(QQuickStyleAttached *newParent, QQuickStyleAttached *oldParent);
#endif
    void inheritStyle(const StyleData &data);
    void propagateStyle(const StyleData &data);
    void resolveGlobalThemeData(const QSharedPointer<QSettings> &settings);
};

QML_DECLARE_TYPEINFO(NeptuneStyle, QML_HAS_ATTACHED_PROPERTIES)

#endif // NEPTUNESTYLE_H
