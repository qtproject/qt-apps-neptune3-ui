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
    Q_PROPERTY(QColor primaryTextColor READ primaryTextColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor disabledTextColor READ disabledTextColor NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(QColor highlightedTextColor READ highlightedTextColor NOTIFY neptuneStyleChanged FINAL)
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

    // Font sizes are already premultiplied by NeptuneStyle::scale
    Q_PROPERTY(int fontSizeXXS READ fontSizeXXS NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeXS READ fontSizeXS NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeS READ fontSizeS NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeM READ fontSizeM NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeL READ fontSizeL NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeXL READ fontSizeXL NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeXXL READ fontSizeXXL NOTIFY scaleChanged FINAL)

    // TODO drop the "font" prefix, this applies to other items like Image
    Q_PROPERTY(qreal fontOpacityHigh READ fontOpacityHigh NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal fontOpacityMedium READ fontOpacityMedium NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal fontOpacityLow READ fontOpacityLow NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal fontOpacityDisabled READ fontOpacityDisabled NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(QString fontFamily READ fontFamily NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(int fontFactor READ fontFactor NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(qreal windowWidth READ windowWidth NOTIFY neptuneStyleChanged FINAL)
    Q_PROPERTY(qreal windowHeight READ windowHeight NOTIFY neptuneStyleChanged FINAL)

    Q_PROPERTY(QString backgroundImage READ backgroundImage NOTIFY neptuneStyleChanged)

    /*
        Scale factor to be applied to pixel values

        Neptune 3 UI was designed for a specific aspect ratio, physical size and DPI.
        In order to support other pixel densities this scale factor has to be applied to all
        pixel values (ie, pixel values have to be multiplied by it).
     */
    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY scaleChanged)

public:
    explicit NeptuneStyle(QObject *parent = nullptr);
    virtual ~NeptuneStyle();

    static NeptuneStyle *qmlAttachedProperties(QObject *object);

    enum Theme { Light, Dark };
    Q_ENUM(Theme)

    enum SystemColor {
        PrimaryTextColor,
        HighlightedTextColor,
        DisabledTextColor,
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
    QColor primaryTextColor() const { return systemColor(PrimaryTextColor); }
    QColor highlightedTextColor() const { return systemColor(HighlightedTextColor); }
    QColor disabledTextColor() const { return systemColor(DisabledTextColor); }
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

    qreal fontOpacityHigh() const;
    qreal fontOpacityMedium() const;
    qreal fontOpacityLow() const;
    qreal fontOpacityDisabled() const;

    Q_INVOKABLE QColor lighter25(const QColor& color);
    Q_INVOKABLE QColor lighter50(const QColor& color);
    Q_INVOKABLE QColor lighter75(const QColor& color);
    Q_INVOKABLE QColor darker25(const QColor& color);
    Q_INVOKABLE QColor darker50(const QColor& color);
    Q_INVOKABLE QColor darker75(const QColor& color);

    QString backgroundImage() const;

    QString fontFamily() const;
    int fontFactor() const;

    qreal windowWidth() const;

    qreal windowHeight() const;

    Theme theme() const;
    void setTheme(Theme);
    void inheritTheme(Theme theme);
    void propagateTheme();

    qreal scale() const;
    void setScale(qreal);

protected:
    void init();
signals:
    void accentColorChanged();
    void neptuneStyleChanged();
    void themeChanged();
    void scaleChanged();

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
    void propagateScale();
};

QML_DECLARE_TYPEINFO(NeptuneStyle, QML_HAS_ATTACHED_PROPERTIES)

#endif // NEPTUNESTYLE_H
