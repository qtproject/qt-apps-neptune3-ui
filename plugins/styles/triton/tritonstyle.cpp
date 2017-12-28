/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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

#include "tritonstyle.h"
#include <QtQml/qqmlinfo.h>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickWindow>
#include <QtGui/QGuiApplication>
#include <QtCore/QSettings>

#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
#include <QtQuickControls2/private/qquickstyle_p.h>
#endif

class ThemeData
{
public:
    ThemeData() {}
    ThemeData(const QHash<TritonStyle::SystemColor, QColor>& newColors, const QString &backgroundImage)
        : colors(newColors)
        , backgroundImage(backgroundImage)
    {}

    QHash<TritonStyle::SystemColor, QColor> colors;
    QString backgroundImage;
};




static QHash<TritonStyle::SystemColor, QColor>
GlobalLightThemeColors {
                      {TritonStyle::PrimaryTextColor, QColor(0xFF000000)},
                      {TritonStyle::DisabledTextColor, QColor(0xFF989898)},
                      {TritonStyle::BackgroundColor, QColor(0xFFF1EFED)},
                      {TritonStyle::ButtonColor, QColor(0xFF969696)},
                      {TritonStyle::HighlightedButtonColor, QColor(0XFFCBCAC8)},

                      {TritonStyle::AccentColor, QColor(0xFFFA9E54)},
                      {TritonStyle::PositiveColor, QColor(0xFF50E3C2)},
                      {TritonStyle::NegativeColor, QColor(0xFF303030)}
                  };

static QHash<TritonStyle::SystemColor, QColor>
GlobalDarkThemeColors {
                     {TritonStyle::PrimaryTextColor, QColor(0xFFFFFFFF)},
                     {TritonStyle::DisabledTextColor, QColor(0xFF989898)},
                     {TritonStyle::BackgroundColor, QColor(0xFF5E5954)},
                     {TritonStyle::ButtonColor, QColor(0xFF969696)},
                     {TritonStyle::HighlightedButtonColor, QColor(0xFF6D6B64)},

                     {TritonStyle::AccentColor, QColor(0xFFFA9E54)},
                     {TritonStyle::PositiveColor, QColor(0xFF50E3C2)},
                     {TritonStyle::NegativeColor, QColor(0xFF303030)}
                 };

//TODO: replace with typedef
static ThemeData GlobalDarkThemeData(GlobalDarkThemeColors, QStringLiteral("bg-home-dark"));
static ThemeData GlobalLightThemeData(GlobalLightThemeColors, QStringLiteral("bg-home"));

static ThemeData& tritonstyle_theme_data(TritonStyle::Theme theme)
{
    return theme == TritonStyle::Dark? GlobalDarkThemeData : GlobalLightThemeData;
}


class StyleData {
public:
    StyleData()
        : font(QGuiApplication::font())
        , fontFactor(1.0)
        , theme(TritonStyle::Light)
        , windowSize(1080, 1920)
    {
        compute();
    }
    StyleData(const StyleData &data)
        : font(data.font)
        , fontFactor(data.fontFactor)
        , theme(data.theme)
        , windowSize(data.windowSize)
    {
        compute();
    }

    void compute() {
        fontSizeXXS = font.pixelSize() * 0.4 * fontFactor;
        fontSizeXS = font.pixelSize() * 0.6 * fontFactor;
        fontSizeS = font.pixelSize() * 0.8 * fontFactor;
        fontSizeM = font.pixelSize() * 1.0 * fontFactor;
        fontSizeL = font.pixelSize() * 1.25 * fontFactor;
        fontSizeXL = font.pixelSize() * 1.5 * fontFactor;
        fontSizeXXL = font.pixelSize() * 1.75 * fontFactor;
    }

    QFont font;
    qreal fontFactor;
    TritonStyle::Theme theme;
    QSize windowSize;
    int fontSizeXXS;
    int fontSizeXS;
    int fontSizeS;
    int fontSizeM;
    int fontSizeL;
    int fontSizeXL;
    int fontSizeXXL;
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
    int value = data.toFloat(&ok);
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

TritonStyle::TritonStyle(QObject *parent)
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    : QQuickAttachedObject(parent)
#else
    : QQuickStyleAttached(parent)
#endif
    , m_data(new StyleData(GlobalStyleData))
{
    init();
}

TritonStyle::~TritonStyle()
{
}

TritonStyle *TritonStyle::qmlAttachedProperties(QObject *object)
{
    return new TritonStyle(object);
}


QColor TritonStyle::systemColor(SystemColor role) const
{
    auto &themeData = tritonstyle_theme_data(m_data->theme);
    return themeData.colors[role];
}

QColor TritonStyle::accentColor() const
{
    return systemColor(AccentColor);
}

QColor TritonStyle::positiveColor() const
{
    return systemColor(PositiveColor);
}

QColor TritonStyle::negativeColor() const
{
    return systemColor(NegativeColor);
}


QColor TritonStyle::lighter25(const QColor& color)
{
    return color.lighter(150);
}

QColor TritonStyle::lighter50(const QColor& color)
{
    return color.lighter(200);
}

QColor TritonStyle::lighter75(const QColor& color)
{
    return color.lighter(400);
}

QColor TritonStyle::darker25(const QColor& color)
{
    return color.darker(150);
}


QColor TritonStyle::darker50(const QColor& color)
{
    return color.darker(200);
}

QColor TritonStyle::darker75(const QColor& color)
{
    return color.darker(400);
}

int TritonStyle::fontSizeXXS() const
{
    return m_data->fontSizeXXS;
}

int TritonStyle::fontSizeXS() const
{
    return m_data->fontSizeXS;
}

int TritonStyle::fontSizeS() const
{
    return m_data->fontSizeS;
}

int TritonStyle::fontSizeM() const
{
    return m_data->fontSizeM;
}

int TritonStyle::fontSizeL() const
{
    return m_data->fontSizeL;
}

int TritonStyle::fontSizeXL() const
{
    return m_data->fontSizeXL;
}

int TritonStyle::fontSizeXXL() const
{
    return m_data->fontSizeXXL;
}

QString TritonStyle::backgroundImage() const
{
    auto &themeData = tritonstyle_theme_data(m_data->theme);
    return themeData.backgroundImage;
}

QString TritonStyle::fontFamily() const
{
    return m_data->font.family();
}

int TritonStyle::fontFactor() const
{
    return m_data->fontFactor;
}

qreal TritonStyle::windowWidth() const
{
    return m_data->windowSize.width();
}

qreal TritonStyle::windowHeight() const
{
    return m_data->windowSize.height();
}

void TritonStyle::init()
{
    static bool initialized = false;
    if (!initialized) {
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
        QSharedPointer<QSettings> settings = QQuickStylePrivate::settings(QStringLiteral("Triton"));
#else
        QSharedPointer<QSettings> settings = QQuickStyleAttached::settings(QStringLiteral("Triton"));
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

        data = resolveSetting(settings, "WindowWidth");
        GlobalStyleData.windowSize.setWidth(toInteger(data, GlobalStyleData.windowSize.width()));

        data = resolveSetting(settings, "WindowHeight");
        GlobalStyleData.windowSize.setHeight(toInteger(data, GlobalStyleData.windowSize.height()));

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

QColor defaultColor(TritonStyle::SystemColor role, TritonStyle::Theme theme)
{
    auto &themeColors = theme == TritonStyle::Light ? GlobalLightThemeColors : GlobalDarkThemeColors;
    return themeColors[role];
}

void TritonStyle::resolveGlobalThemeData(const QSharedPointer<QSettings> &settings)
{
    QMetaEnum themeEnumeration = QMetaEnum::fromType<Theme>();
    QMetaEnum enumeration = QMetaEnum::fromType<SystemColor>();

    for (int themeIndex=0; themeIndex<themeEnumeration.keyCount(); themeIndex++) {
        QByteArray themeKey(themeEnumeration.key(themeIndex));
        Theme themeValue = static_cast<Theme>(themeEnumeration.value(themeIndex));
        ThemeData& themeData = tritonstyle_theme_data(themeValue);

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
void TritonStyle::attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent)
#else
void TritonStyle::parentStyleChange(QQuickStyleAttached *newParent, QQuickStyleAttached *oldParent)
#endif
{
    Q_UNUSED(oldParent);
    TritonStyle* triton = qobject_cast<TritonStyle *>(newParent);
    if (triton)
        inheritStyle(*triton->m_data);
}

void TritonStyle::inheritStyle(const StyleData& data)
{
    m_data.reset(new StyleData(data));
    propagateStyle(data);
    emit tritonStyleChanged();
}

void TritonStyle::propagateStyle(const StyleData& data)
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    const auto styles = attachedChildren();
#else
    const auto styles = childStyles();
#endif
    for (auto *child: styles) {
        TritonStyle* triton = qobject_cast<TritonStyle *>(child);
        if (triton)
            triton->inheritStyle(data);
    }
}

auto TritonStyle::theme() const -> Theme
{
    return m_data->theme;
}

void TritonStyle::setTheme(Theme value)
{
    if (m_data->theme != value) {
        m_data->theme = value;
        propagateTheme();
        emit themeChanged();
        emit tritonStyleChanged();
    }
}

void TritonStyle::propagateTheme()
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 10, 0)
    const auto styles = attachedChildren();
#else
    const auto styles = childStyles();
#endif
    for (auto *child: styles) {
        auto *tritonStyle = qobject_cast<TritonStyle *>(child);
        if (tritonStyle)
            tritonStyle->inheritTheme(m_data->theme);
    }
}

void TritonStyle::inheritTheme(Theme theme)
{
    if (m_data->theme == theme)
        return;

    m_data->theme = theme;
    propagateTheme();
    emit themeChanged();
    emit tritonStyleChanged();
}
