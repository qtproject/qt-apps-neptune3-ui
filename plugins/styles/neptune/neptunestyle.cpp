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

#include "neptunestyle.h"
#include <QtQml/qqmlinfo.h>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickWindow>
#include <QtGui/QGuiApplication>
#include <QtCore/QSettings>
#include <QQmlEngine>

#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
#include <QtQuickControls2/private/qquickstyle_p.h>
#endif

class ThemeData
{
public:
    ThemeData() {}
    ThemeData(const QHash<NeptuneStyle::SystemColor, QColor>& newColors, const QString &backgroundImage)
        : colors(newColors)
        , backgroundImage(backgroundImage)
    {}

    QHash<NeptuneStyle::SystemColor, QColor> colors;
    QString backgroundImage;
};




static QHash<NeptuneStyle::SystemColor, QColor>
GlobalLightThemeColors {
                      {NeptuneStyle::PrimaryTextColor, QColor(0xFF000000)},
                      {NeptuneStyle::HighlightedTextColor, QColor(0xFFCE8042)},
                      {NeptuneStyle::DisabledTextColor, QColor(0xFF989898)},
                      {NeptuneStyle::BackgroundColor, QColor(0xFFF1EFED)},
                      {NeptuneStyle::ButtonColor, QColor(0xFF969696)},
                      {NeptuneStyle::HighlightedButtonColor, QColor(0XFFCBCAC8)},

                      {NeptuneStyle::AccentColor, QColor(0xFFFA9E54)},
                      {NeptuneStyle::MainColor, QColor(0xFFFFFFFF)},
                      {NeptuneStyle::OffMainColor, QColor(0xFFF7F4F2)},
                      {NeptuneStyle::AccentDetailColor, QColor(0xFFCE8042)},
                      {NeptuneStyle::ContrastColor, QColor(0xFF000000)},
                      {NeptuneStyle::ClusterMarksColor, QColor(0xFF916E51)}
                  };

static QHash<NeptuneStyle::SystemColor, QColor>
GlobalDarkThemeColors {
                     {NeptuneStyle::PrimaryTextColor, QColor(0xFFFFFFFF)},
                     {NeptuneStyle::HighlightedTextColor, QColor(0xFFCE8042)},
                     {NeptuneStyle::DisabledTextColor, QColor(0xFF989898)},
                     {NeptuneStyle::BackgroundColor, QColor(0xFF5E5954)},
                     {NeptuneStyle::ButtonColor, QColor(0xFF969696)},
                     {NeptuneStyle::HighlightedButtonColor, QColor(0xFF6D6B64)},

                     {NeptuneStyle::AccentColor, QColor(0xFFFA9E54)},
                     {NeptuneStyle::MainColor, QColor(0xFF000000)},
                     {NeptuneStyle::OffMainColor, QColor(0xFF575757)},
                     {NeptuneStyle::AccentDetailColor, QColor(0xFFCE8042)},
                     {NeptuneStyle::ContrastColor, QColor(0xFFFFFFFF)},
                     {NeptuneStyle::ClusterMarksColor, QColor(0xFF916E51)}
                 };

//TODO: replace with typedef
static ThemeData GlobalDarkThemeData(GlobalDarkThemeColors, QStringLiteral("bg-home-dark"));
static ThemeData GlobalLightThemeData(GlobalLightThemeColors, QStringLiteral("bg-home"));

static ThemeData& neptunestyle_theme_data(NeptuneStyle::Theme theme)
{
    return theme == NeptuneStyle::Dark? GlobalDarkThemeData : GlobalLightThemeData;
}


class StyleData {
public:
    StyleData()
        : font(QGuiApplication::font())
        , fontFactor(1.0)
        , theme(NeptuneStyle::Light)
        , scale(1.0)
    {
        compute();
    }
    StyleData(const StyleData &data)
        : font(data.font)
        , fontFactor(data.fontFactor)
        , theme(data.theme)
        , scale(data.scale)
    {
        compute();
    }

    void compute() {
        fontSizeXXS = qRound(font.pixelSize() * 0.4 * fontFactor);
        fontSizeXS = qRound(font.pixelSize() * 0.6 * fontFactor);
        fontSizeS = qRound(font.pixelSize() * 0.8 * fontFactor);
        fontSizeM = qRound(font.pixelSize() * 1.0 * fontFactor);
        fontSizeL = qRound(font.pixelSize() * 1.25 * fontFactor);
        fontSizeXL = qRound(font.pixelSize() * 1.5 * fontFactor);
        fontSizeXXL = qRound(font.pixelSize() * 1.75 * fontFactor);
    }

    QFont font;
    qreal fontFactor;
    NeptuneStyle::Theme theme;
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


template <typename Enum>
static Enum toEnumValue(const QByteArray &data, Enum defaultValue)
{
    QMetaEnum enumeration = QMetaEnum::fromType<Enum>();
    bool ok;
    Enum value = static_cast<Enum>(enumeration.keyToValue(data, &ok));
    if (ok)
        return value;
    return defaultValue;
}

static int toInteger(const QByteArray &data, int defaultValue)
{
    bool ok;
    int value = data.toInt(&ok);
    if (ok)
        return value;
    return defaultValue;
}

static qreal toReal(const QByteArray &data, qreal defaultValue)
{
    bool ok;
    qreal value = data.toDouble(&ok);
    if (ok)
        return value;
    return defaultValue;
}

QString toString(const QByteArray& data, const QString& defaultValue)
{
    QString value = QString::fromLocal8Bit(data);
    if (value.isEmpty())
        return defaultValue;
    return value;
}

QColor toColor(const QByteArray& data, const QColor& defaultValue)
{
    QString value = QString::fromLocal8Bit(data);
    if (value.isEmpty())
        return defaultValue;
    return QColor(value);
}

static QByteArray resolveSetting(const QSharedPointer<QSettings> &settings, const QString &name, const QByteArray &env=QByteArray())
{
    QByteArray value;
    if (!env.isNull())
        value = qgetenv(env);
    if (value.isNull() && !settings.isNull())
        value = settings->value(name).toByteArray();
    return value;
}

NeptuneStyle::NeptuneStyle(QObject *parent)
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    : QQuickAttachedObject(parent)
#else
    : QQuickStyleAttached(parent)
#endif
    , m_data(new StyleData(GlobalStyleData))
{
    init();
}

NeptuneStyle::~NeptuneStyle()
{
}

NeptuneStyle *NeptuneStyle::qmlAttachedProperties(QObject *object)
{
    return new NeptuneStyle(object);
}


QColor NeptuneStyle::systemColor(SystemColor role) const
{
    auto &themeData = neptunestyle_theme_data(m_data->theme);
    return themeData.colors[role];
}

QColor NeptuneStyle::accentColor() const
{
    return m_accentColor.isValid() ? m_accentColor : systemColor(AccentColor);
}

void NeptuneStyle::setAccentColor(const QColor &accent)
{
    if (m_accentColor == accent || !accent.isValid())
        return;

    m_accentColor = accent;
    propagateAccentColor();
    emit accentColorChanged();
}

void NeptuneStyle::propagateAccentColor()
{
    for (QQuickAttachedObject *child : attachedChildren()) {
        NeptuneStyle* neptune = qobject_cast<NeptuneStyle *>(child);
        if (neptune)
            neptune->setAccentColor(m_accentColor);
    }
}

QColor NeptuneStyle::mainColor() const
{
    return systemColor(MainColor);
}

QColor NeptuneStyle::offMainColor() const
{
    return systemColor(OffMainColor);
}

QColor NeptuneStyle::accentDetailColor() const
{
    return systemColor(AccentDetailColor);
}

QColor NeptuneStyle::contrastColor() const
{
    return systemColor(ContrastColor);
}

QColor NeptuneStyle::clusterMarksColor() const
{
    return systemColor(ClusterMarksColor);
}

QColor NeptuneStyle::lighter25(const QColor& color)
{
    return color.lighter(150);
}

QColor NeptuneStyle::lighter50(const QColor& color)
{
    return color.lighter(200);
}

QColor NeptuneStyle::lighter75(const QColor& color)
{
    return color.lighter(400);
}

QColor NeptuneStyle::darker25(const QColor& color)
{
    return color.darker(150);
}

QColor NeptuneStyle::darker50(const QColor& color)
{
    return color.darker(200);
}

QColor NeptuneStyle::darker75(const QColor& color)
{
    return color.darker(400);
}

int NeptuneStyle::fontSizeXXS() const
{
    return qRound(m_data->fontSizeXXS * m_data->scale);
}

int NeptuneStyle::fontSizeXS() const
{
    return qRound(m_data->fontSizeXS * m_data->scale);
}

int NeptuneStyle::fontSizeS() const
{
    return qRound(m_data->fontSizeS * m_data->scale);
}

int NeptuneStyle::fontSizeM() const
{
    return qRound(m_data->fontSizeM * m_data->scale);
}

int NeptuneStyle::fontSizeL() const
{
    return qRound(m_data->fontSizeL * m_data->scale);
}

int NeptuneStyle::fontSizeXL() const
{
    return qRound(m_data->fontSizeXL * m_data->scale);
}

int NeptuneStyle::fontSizeXXL() const
{
    return qRound(m_data->fontSizeXXL * m_data->scale);
}

QString NeptuneStyle::backgroundImage() const
{
    auto &themeData = neptunestyle_theme_data(m_data->theme);
    return themeData.backgroundImage;
}

QString NeptuneStyle::fontFamily() const
{
    return m_data->font.family();
}

int NeptuneStyle::fontFactor() const
{
    return qRound(m_data->fontFactor);
}

void NeptuneStyle::init()
{
    static bool initialized = false;
    if (!initialized) {
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
        QSharedPointer<QSettings> settings = QQuickStylePrivate::settings(QStringLiteral("Neptune"));
#else
        QSharedPointer<QSettings> settings = QQuickStyleAttached::settings(QStringLiteral("Neptune"));
#endif
        QByteArray data;

        data = resolveSetting(settings, "Theme");
        GlobalStyleData.theme = toEnumValue<Theme>(data, GlobalStyleData.theme);

        data = resolveSetting(settings, "FontSize");
        GlobalStyleData.font.setPixelSize(toInteger(data, GlobalStyleData.font.pixelSize()));

        data = resolveSetting(settings, "FontFactor");
        GlobalStyleData.fontFactor = toReal(data, GlobalStyleData.fontFactor);

        data = resolveSetting(settings, "FontFamily");
        GlobalStyleData.font.setFamily(toString(data, GlobalStyleData.font.family()));

        resolveGlobalThemeData(settings);

        QGuiApplication::setFont(GlobalStyleData.font);
    }

    initialized = true;
    m_data.reset(new StyleData(GlobalStyleData));
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    QQuickAttachedObject::init();
#else
    QQuickStyleAttached::init();
#endif
}

QColor defaultColor(NeptuneStyle::SystemColor role, NeptuneStyle::Theme theme)
{
    auto &themeColors = theme == NeptuneStyle::Light ? GlobalLightThemeColors : GlobalDarkThemeColors;
    return themeColors[role];
}

void NeptuneStyle::resolveGlobalThemeData(const QSharedPointer<QSettings> &settings)
{
    QMetaEnum themeEnumeration = QMetaEnum::fromType<Theme>();
    QMetaEnum enumeration = QMetaEnum::fromType<SystemColor>();

    for (int themeIndex=0; themeIndex<themeEnumeration.keyCount(); themeIndex++) {
        QByteArray themeKey(themeEnumeration.key(themeIndex));
        Theme themeValue = static_cast<Theme>(themeEnumeration.value(themeIndex));
        ThemeData& themeData = neptunestyle_theme_data(themeValue);

        for (int i=0; i<enumeration.keyCount(); i++) {
            SystemColor value = static_cast<SystemColor>(enumeration.value(i));
            QByteArray settingsKey = themeKey + '/' + QByteArray(enumeration.key(i));
            QByteArray data = resolveSetting(settings, settingsKey);
            QColor color = toColor(data, defaultColor(value, themeValue));
            themeData.colors.insert(value, color);
        }
    }
}

#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
void NeptuneStyle::attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent)
#else
void NeptuneStyle::parentStyleChange(QQuickStyleAttached *newParent, QQuickStyleAttached *oldParent)
#endif
{
    Q_UNUSED(oldParent);
    NeptuneStyle* neptune = qobject_cast<NeptuneStyle *>(newParent);
    if (neptune) {
        inheritStyle(*neptune->m_data);
        setAccentColor(neptune->accentColor());
    }
}

void NeptuneStyle::inheritStyle(const StyleData& data)
{
    m_data.reset(new StyleData(data));
    propagateStyle(data);
    emit neptuneStyleChanged();
    emit accentColorChanged();
    emit scaleChanged();
}

void NeptuneStyle::propagateStyle(const StyleData& data)
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    const auto styles = attachedChildren();
#else
    const auto styles = childStyles();
#endif
    for (auto *child: styles) {
        NeptuneStyle* neptune = qobject_cast<NeptuneStyle *>(child);
        if (neptune)
            neptune->inheritStyle(data);
    }
}

auto NeptuneStyle::theme() const -> Theme
{
    return m_data->theme;
}

void NeptuneStyle::setTheme(Theme value)
{
    if (m_data->theme != value) {
        m_data->theme = value;
        propagateTheme();
        emit themeChanged();
        emit neptuneStyleChanged();
        emit accentColorChanged();
    }
}

void NeptuneStyle::propagateTheme()
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    const auto styles = attachedChildren();
#else
    const auto styles = childStyles();
#endif
    for (auto *child: styles) {
        auto *neptuneStyle = qobject_cast<NeptuneStyle *>(child);
        if (neptuneStyle)
            neptuneStyle->inheritTheme(m_data->theme);
    }
}

void NeptuneStyle::inheritTheme(Theme theme)
{
    if (m_data->theme == theme)
        return;

    m_data->theme = theme;
    propagateTheme();
    emit themeChanged();
    emit neptuneStyleChanged();
    emit accentColorChanged();
}

qreal NeptuneStyle::fontOpacityDisabled() const
{
    return 0.3;
}

qreal NeptuneStyle::fontOpacityLow() const
{
    return 0.4;
}

qreal NeptuneStyle::fontOpacityMedium() const
{
    return 0.6;
}

qreal NeptuneStyle::fontOpacityHigh() const
{
    return 0.94;
}

qreal NeptuneStyle::scale() const
{
    return m_data->scale;
}

void NeptuneStyle::setScale(qreal value)
{
    if (value == m_data->scale)
        return;

    m_data->scale = value;
    propagateScale();
    m_dp = QJSValue();
    emit scaleChanged();
}

void NeptuneStyle::propagateScale()
{
    for (QQuickAttachedObject *child : attachedChildren()) {
        NeptuneStyle* neptune = qobject_cast<NeptuneStyle *>(child);
        if (neptune)
            neptune->setScale(m_data->scale);
    }
}

QJSValue NeptuneStyle::dp() const
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
