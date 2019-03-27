/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

#include "neptuneiconlabel.h"
#include "neptuneiconlabel_p.h"
#include <QtQuickControls2/private/qquickiconimage_p.h> // #include "qquickiconimage_p.h"
#include <QtQuickControls2/private/qquickmnemoniclabel_p.h> // #include "qquickmnemoniclabel_p.h"

#include <QtGui/private/qguiapplication_p.h>
#include <QtQuick/private/qquickitem_p.h>
#include <QtQuick/private/qquicktext_p.h>

#include <QFileSelector>

QT_BEGIN_NAMESPACE

static void beginClass(QQuickItem *item)
{
    if (QQmlParserStatus *parserStatus = qobject_cast<QQmlParserStatus *>(item))
        parserStatus->classBegin();
}

static void completeComponent(QQuickItem *item)
{
    if (QQmlParserStatus *parserStatus = qobject_cast<QQmlParserStatus *>(item))
        parserStatus->componentComplete();
}

NeptuneIconLabelPrivate::NeptuneIconLabelPrivate()
    : mirrored(false),
      display(NeptuneIconLabel::TextBesideIcon),
      alignment(Qt::AlignCenter),
      spacing(0),
      topPadding(0),
      leftPadding(0),
      rightPadding(0),
      bottomPadding(0),
      image(nullptr),
      label(nullptr)
{
}

bool NeptuneIconLabelPrivate::hasIcon() const
{
    return display != NeptuneIconLabel::TextOnly && !icon.isEmpty();
}

bool NeptuneIconLabelPrivate::hasText() const
{
    return display != NeptuneIconLabel::IconOnly && !text.isEmpty();
}

bool NeptuneIconLabelPrivate::createImage()
{
    Q_Q(NeptuneIconLabel);
    if (image)
        return false;

    image = new QQuickIconImage(q);
    watchChanges(image);
    beginClass(image);
    image->setObjectName(QStringLiteral("image"));
    image->setName(icon.name());
    QFileSelector selector;
    image->setSource(selector.select(icon.source()));
    image->setSourceSize(QSize(icon.width(), icon.height()));
    image->setColor(icon.color());
    QQmlEngine::setContextForObject(image, qmlContext(q));
    if (componentComplete)
        completeComponent(image);
    return true;
}

bool NeptuneIconLabelPrivate::destroyImage()
{
    if (!image)
        return false;

    unwatchChanges(image);
    delete image;
    image = nullptr;
    return true;
}

bool NeptuneIconLabelPrivate::updateImage()
{
    if (!hasIcon())
        return destroyImage();
    return createImage();
}

void NeptuneIconLabelPrivate::syncImage()
{
    if (!image || icon.isEmpty())
        return;

    image->setName(icon.name());
    QFileSelector selector;
    image->setSource(selector.select(icon.source()));
    image->setSourceSize(QSize(icon.width(), icon.height()));
    image->setColor(icon.color());
    const int valign = alignment & Qt::AlignVertical_Mask;
    image->setVerticalAlignment(static_cast<QQuickImage::VAlignment>(valign));
    const int halign = alignment & Qt::AlignHorizontal_Mask;
    image->setHorizontalAlignment(static_cast<QQuickImage::HAlignment>(halign));
}

void NeptuneIconLabelPrivate::updateOrSyncImage()
{
    if (updateImage()) {
        if (componentComplete) {
            updateImplicitSize();
            layout();
        }
    } else {
        syncImage();
    }
}

bool NeptuneIconLabelPrivate::createLabel()
{
    Q_Q(NeptuneIconLabel);
    if (label)
        return false;

    label = new QQuickMnemonicLabel(q);
    watchChanges(label);
    beginClass(label);
    label->setObjectName(QStringLiteral("label"));
    label->setFont(font);
    label->setColor(color);
    label->setElideMode(QQuickText::ElideRight);
    const int valign = alignment & Qt::AlignVertical_Mask;
    label->setVAlign(static_cast<QQuickText::VAlignment>(valign));
    const int halign = alignment & Qt::AlignHorizontal_Mask;
    label->setHAlign(static_cast<QQuickText::HAlignment>(halign));
    label->setText(text);
    if (componentComplete)
        completeComponent(label);
    return true;
}

bool NeptuneIconLabelPrivate::destroyLabel()
{
    if (!label)
        return false;

    unwatchChanges(label);
    delete label;
    label = nullptr;
    return true;
}

bool NeptuneIconLabelPrivate::updateLabel()
{
    if (!hasText())
        return destroyLabel();
    return createLabel();
}

void NeptuneIconLabelPrivate::syncLabel()
{
    if (!label)
        return;

    label->setText(text);
}

void NeptuneIconLabelPrivate::updateOrSyncLabel()
{
    if (updateLabel()) {
        if (componentComplete) {
            updateImplicitSize();
            layout();
        }
    } else {
        syncLabel();
    }
}

void NeptuneIconLabelPrivate::updateImplicitSize()
{
    Q_Q(NeptuneIconLabel);
    const bool showIcon = image && hasIcon();
    const bool showText = label && hasText();
    const qreal horizontalPadding = leftPadding + rightPadding;
    const qreal verticalPadding = topPadding + bottomPadding;
    const qreal iconImplicitWidth = showIcon ? image->implicitWidth() : 0;
    const qreal iconImplicitHeight = showIcon ? image->implicitHeight() : 0;
    const qreal textImplicitWidth = showText ? label->implicitWidth() : 0;
    const qreal textImplicitHeight = showText ? label->implicitHeight() : 0;
    const qreal effectiveSpacing = showText && showIcon && image->implicitWidth() > 0 ? spacing : 0;
    const qreal implicitWidth = display == NeptuneIconLabel::TextBesideIcon ? iconImplicitWidth + textImplicitWidth + effectiveSpacing
                                                                           : qMax(iconImplicitWidth, textImplicitWidth);
    const qreal implicitHeight = display == NeptuneIconLabel::TextUnderIcon ? iconImplicitHeight + textImplicitHeight + effectiveSpacing
                                                                           : qMax(iconImplicitHeight, textImplicitHeight);
    q->setImplicitSize(implicitWidth + horizontalPadding, implicitHeight + verticalPadding);
}

// adapted from QStyle::alignedRect()
static QRectF alignedRect(bool mirrored, Qt::Alignment alignment, const QSizeF &size, const QRectF &rectangle)
{
    alignment = QGuiApplicationPrivate::visualAlignment(mirrored ? Qt::RightToLeft : Qt::LeftToRight, alignment);
    qreal x = rectangle.x();
    qreal y = rectangle.y();
    const qreal w = size.width();
    const qreal h = size.height();
    if ((alignment & Qt::AlignVCenter) == Qt::AlignVCenter)
        y += rectangle.height() / 2 - h / 2;
    else if ((alignment & Qt::AlignBottom) == Qt::AlignBottom)
        y += rectangle.height() - h;
    if ((alignment & Qt::AlignRight) == Qt::AlignRight)
        x += rectangle.width() - w;
    else if ((alignment & Qt::AlignHCenter) == Qt::AlignHCenter)
        x += rectangle.width() / 2 - w / 2;
    return QRectF(x, y, w, h);
}

void NeptuneIconLabelPrivate::layout()
{
    if (!componentComplete)
        return;

    const qreal availableWidth = width - leftPadding - rightPadding;
    const qreal availableHeight = height - topPadding - bottomPadding;

    switch (display) {
    case NeptuneIconLabel::IconOnly:
        if (image) {
            const QRectF iconRect = alignedRect(mirrored, alignment,
                                                QSizeF(qMin(image->implicitWidth() * iconScale, availableWidth),
                                                       qMin(image->implicitHeight() * iconScale, availableHeight)),
                                                QRectF(leftPadding, topPadding, availableWidth, availableHeight));
            image->setSize(iconRect.size());
            image->setPosition(iconRect.topLeft());
        }
        break;
    case NeptuneIconLabel::TextOnly:
        if (label) {
            const QRectF textRect = alignedRect(mirrored, alignment,
                                                QSizeF(qMin(label->implicitWidth(), availableWidth),
                                                       qMin(label->implicitHeight(), availableHeight)),
                                                QRectF(leftPadding, topPadding, availableWidth, availableHeight));
            label->setSize(textRect.size());
            label->setPosition(textRect.topLeft());
        }
        break;

    case NeptuneIconLabel::TextUnderIcon: {
        // Work out the sizes first, as the positions depend on them.
        QSizeF iconSize;
        QSizeF textSize;
        if (image) {
            iconSize.setWidth(qMin(image->implicitWidth() * iconScale, availableWidth));
            iconSize.setHeight(qMin(image->implicitHeight() * iconScale, availableHeight));
        }
        qreal effectiveSpacing = 0;
        if (label) {
            if (!iconSize.isEmpty())
                effectiveSpacing = spacing;
            textSize.setWidth(qMin(label->implicitWidth(), availableWidth));
            textSize.setHeight(qMin(label->implicitHeight(), availableHeight - iconSize.height() - effectiveSpacing));
        }

        QRectF combinedRect = alignedRect(mirrored, alignment,
                                          QSizeF(qMax(iconSize.width(), textSize.width()),
                                                 iconSize.height() + effectiveSpacing + textSize.height()),
                                          QRectF(leftPadding, topPadding, availableWidth, availableHeight));
        if (image) {
            QRectF iconRect = alignedRect(mirrored, Qt::AlignHCenter | Qt::AlignTop, iconSize, combinedRect);
            image->setSize(iconRect.size());
            image->setPosition(iconRect.topLeft());
        }
        if (label) {
            QRectF textRect = alignedRect(mirrored, Qt::AlignHCenter | Qt::AlignBottom, textSize, combinedRect);
            label->setSize(textRect.size());
            label->setPosition(textRect.topLeft());
        }
        break;
    }

    case NeptuneIconLabel::TextBesideIcon:
    default:
        // Work out the sizes first, as the positions depend on them.
        QSizeF iconSize(0, 0);
        QSizeF textSize(0, 0);
        if (image) {
            iconSize.setWidth(qMin(image->implicitWidth() * iconScale, availableWidth));
            iconSize.setHeight(qMin(image->implicitHeight() * iconScale, availableHeight));
        }
        qreal effectiveSpacing = 0;
        if (label) {
            if (!iconSize.isEmpty())
                effectiveSpacing = spacing;
            textSize.setWidth(qMin(label->implicitWidth(), availableWidth - iconSize.width() - effectiveSpacing));
            textSize.setHeight(qMin(label->implicitHeight(), availableHeight));
        }

        const QRectF combinedRect = alignedRect(mirrored, alignment,
                                                QSizeF(iconSize.width() + effectiveSpacing + textSize.width(),
                                                       qMax(iconSize.height(), textSize.height())),
                                                QRectF(leftPadding, topPadding, availableWidth, availableHeight));
        if (image) {
            const QRectF iconRect = alignedRect(mirrored, Qt::AlignLeft | Qt::AlignVCenter, iconSize, combinedRect);
            image->setSize(iconRect.size());
            image->setPosition(iconRect.topLeft());
        }
        if (label) {
            const QRectF textRect = alignedRect(mirrored, Qt::AlignRight | Qt::AlignVCenter, textSize, combinedRect);
            label->setSize(textRect.size());
            label->setPosition(textRect.topLeft());
        }
        break;
    }
}

static const QQuickItemPrivate::ChangeTypes itemChangeTypes =
    QQuickItemPrivate::ImplicitWidth
    | QQuickItemPrivate::ImplicitHeight
    | QQuickItemPrivate::Destroyed;

void NeptuneIconLabelPrivate::watchChanges(QQuickItem *item)
{
    QQuickItemPrivate *itemPrivate = QQuickItemPrivate::get(item);
    itemPrivate->addItemChangeListener(this, itemChangeTypes);
}

void NeptuneIconLabelPrivate::unwatchChanges(QQuickItem* item)
{
    QQuickItemPrivate *itemPrivate = QQuickItemPrivate::get(item);
    itemPrivate->removeItemChangeListener(this, itemChangeTypes);
}

void NeptuneIconLabelPrivate::itemImplicitWidthChanged(QQuickItem *)
{
    updateImplicitSize();
    layout();
}

void NeptuneIconLabelPrivate::itemImplicitHeightChanged(QQuickItem *)
{
    updateImplicitSize();
    layout();
}

void NeptuneIconLabelPrivate::itemDestroyed(QQuickItem *item)
{
    unwatchChanges(item);
    if (item == image)
        image = nullptr;
    else if (item == label)
        label = nullptr;
}

NeptuneIconLabel::NeptuneIconLabel(QQuickItem *parent)
    : QQuickItem(*(new NeptuneIconLabelPrivate), parent)
{
}

NeptuneIconLabel::~NeptuneIconLabel()
{
    Q_D(NeptuneIconLabel);
    if (d->image)
        d->unwatchChanges(d->image);
    if (d->label)
        d->unwatchChanges(d->label);
}

QQuickIcon NeptuneIconLabel::icon() const
{
    Q_D(const NeptuneIconLabel);
    return d->icon;
}

void NeptuneIconLabel::setIcon(const QQuickIcon &icon)
{
    Q_D(NeptuneIconLabel);
    if (d->icon == icon)
        return;

    d->icon = icon;
    d->updateOrSyncImage();
}

qreal NeptuneIconLabel::iconScale() const
{
    Q_D(const NeptuneIconLabel);
    return d->iconScale;
}

void NeptuneIconLabel::setIconScale(qreal scale)
{
    Q_D(NeptuneIconLabel);
    if (d->iconScale == scale)
        return;

    d->iconScale = scale;
}

QString NeptuneIconLabel::text() const
{
    Q_D(const NeptuneIconLabel);
    return d->text;
}

void NeptuneIconLabel::setText(const QString text)
{
    Q_D(NeptuneIconLabel);
    if (d->text == text)
        return;

    d->text = text;
    d->updateOrSyncLabel();
}

QFont NeptuneIconLabel::font() const
{
    Q_D(const NeptuneIconLabel);
    return d->font;
}

void NeptuneIconLabel::setFont(const QFont &font)
{
    Q_D(NeptuneIconLabel);
    if (d->font == font)
        return;

    d->font = font;
    if (d->label)
        d->label->setFont(font);
}

QColor NeptuneIconLabel::color() const
{
    Q_D(const NeptuneIconLabel);
    return d->color;
}

void NeptuneIconLabel::setColor(const QColor &color)
{
    Q_D(NeptuneIconLabel);
    if (d->color == color)
        return;

    d->color = color;
    if (d->label)
        d->label->setColor(color);
}

NeptuneIconLabel::Display NeptuneIconLabel::display() const
{
    Q_D(const NeptuneIconLabel);
    return d->display;
}

void NeptuneIconLabel::setDisplay(Display display)
{
    Q_D(NeptuneIconLabel);
    if (d->display == display)
        return;

    d->display = display;
    d->updateImage();
    d->updateLabel();
    d->updateImplicitSize();
    d->layout();
}

qreal NeptuneIconLabel::spacing() const
{
    Q_D(const NeptuneIconLabel);
    return d->spacing;
}

void NeptuneIconLabel::setSpacing(qreal spacing)
{
    Q_D(NeptuneIconLabel);
    if (qFuzzyCompare(d->spacing, spacing))
        return;

    d->spacing = spacing;
    if (d->image && d->label) {
        d->updateImplicitSize();
        d->layout();
    }
}

bool NeptuneIconLabel::isMirrored() const
{
    Q_D(const NeptuneIconLabel);
    return d->mirrored;
}

void NeptuneIconLabel::setMirrored(bool mirrored)
{
    Q_D(NeptuneIconLabel);
    if (d->mirrored == mirrored)
        return;

    d->mirrored = mirrored;
    d->layout();
}

Qt::Alignment NeptuneIconLabel::alignment() const
{
    Q_D(const NeptuneIconLabel);
    return d->alignment;
}

void NeptuneIconLabel::setAlignment(Qt::Alignment alignment)
{
    Q_D(NeptuneIconLabel);
    const int valign = alignment & Qt::AlignVertical_Mask;
    const int halign = alignment & Qt::AlignHorizontal_Mask;
    const uint align = (valign ? valign : Qt::AlignVCenter) | (halign ? halign : Qt::AlignHCenter);
    if (d->alignment == align)
        return;

    d->alignment = static_cast<Qt::Alignment>(align);
    if (d->label) {
        d->label->setVAlign(static_cast<QQuickText::VAlignment>(valign));
        d->label->setHAlign(static_cast<QQuickText::HAlignment>(halign));
    }
    if (d->image) {
        d->image->setVerticalAlignment(static_cast<QQuickImage::VAlignment>(valign));
        d->image->setHorizontalAlignment(static_cast<QQuickImage::HAlignment>(halign));
    }
    d->layout();
}

qreal NeptuneIconLabel::topPadding() const
{
    Q_D(const NeptuneIconLabel);
    return d->topPadding;
}

void NeptuneIconLabel::setTopPadding(qreal padding)
{
    Q_D(NeptuneIconLabel);
    if (qFuzzyCompare(d->topPadding, padding))
        return;

    d->topPadding = padding;
    d->updateImplicitSize();
    d->layout();
}

void NeptuneIconLabel::resetTopPadding()
{
    setTopPadding(0);
}

qreal NeptuneIconLabel::leftPadding() const
{
    Q_D(const NeptuneIconLabel);
    return d->leftPadding;
}

void NeptuneIconLabel::setLeftPadding(qreal padding)
{
    Q_D(NeptuneIconLabel);
    if (qFuzzyCompare(d->leftPadding, padding))
        return;

    d->leftPadding = padding;
    d->updateImplicitSize();
    d->layout();
}

void NeptuneIconLabel::resetLeftPadding()
{
    setLeftPadding(0);
}

qreal NeptuneIconLabel::rightPadding() const
{
    Q_D(const NeptuneIconLabel);
    return d->rightPadding;
}

void NeptuneIconLabel::setRightPadding(qreal padding)
{
    Q_D(NeptuneIconLabel);
    if (qFuzzyCompare(d->rightPadding, padding))
        return;

    d->rightPadding = padding;
    d->updateImplicitSize();
    d->layout();
}

void NeptuneIconLabel::resetRightPadding()
{
    setRightPadding(0);
}

qreal NeptuneIconLabel::bottomPadding() const
{
    Q_D(const NeptuneIconLabel);
    return d->bottomPadding;
}

void NeptuneIconLabel::setBottomPadding(qreal padding)
{
    Q_D(NeptuneIconLabel);
    if (qFuzzyCompare(d->bottomPadding, padding))
        return;

    d->bottomPadding = padding;
    d->updateImplicitSize();
    d->layout();
}

void NeptuneIconLabel::resetBottomPadding()
{
    setBottomPadding(0);
}

void NeptuneIconLabel::componentComplete()
{
    Q_D(NeptuneIconLabel);
    if (d->image)
        completeComponent(d->image);
    if (d->label)
        completeComponent(d->label);
    QQuickItem::componentComplete();
    d->layout();
}

void NeptuneIconLabel::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    Q_D(NeptuneIconLabel);
    QQuickItem::geometryChanged(newGeometry, oldGeometry);
    d->layout();
}

QT_END_NAMESPACE
