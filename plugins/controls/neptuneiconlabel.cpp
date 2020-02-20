/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

#include "neptuneiconlabel.h"
#include "neptuneiconlabel_p.h"
#include <QtQuickControls2/private/qquickiconimage_p.h>
#include <QtQuickControls2/private/qquickmnemoniclabel_p.h>

#include <QtGui/private/qguiapplication_p.h>
#include <QtQuick/private/qquickitem_p.h>
#include <QtQuick/private/qquicktext_p.h>
#include <QtQml>

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
    QObject::connect(image, &QQuickIconImage::statusChanged,
                     q, &NeptuneIconLabel::onImageStatusChanged);
    watchChanges(image);
    beginClass(image);
    image->setObjectName(QStringLiteral("image"));
    image->setName(icon.name());
    QFileSelector selector;
    image->setSource(selector.select(icon.source()));
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
    qreal iconImplicitWidth = showIcon ? image->implicitWidth() : 0;
    qreal iconImplicitHeight = showIcon ? image->implicitHeight() : 0;
    const qreal textImplicitWidth = showText ? label->implicitWidth() : 0;
    const qreal textImplicitHeight = showText ? label->implicitHeight() : 0;
    const qreal effectiveSpacing = showText && showIcon && image->implicitWidth() > 0 ? spacing : 0;

    // for Pad we apply scaling to image object, so it will be *iconScale size in result
    // implicitWidth of image is equal to 1.0 scaled image
    if (iconFillMode == QQuickImage::Pad) {
        iconImplicitWidth *= iconScale;
        iconImplicitHeight *= iconScale;
    } else {
        iconImplicitWidth = iconRectWidth;
        iconImplicitHeight = iconRectHeight;
    }

    const qreal implicitWidth = display == NeptuneIconLabel::TextBesideIcon
            ? iconImplicitWidth + textImplicitWidth + effectiveSpacing
            : qMax(iconImplicitWidth, textImplicitWidth);
    const qreal implicitHeight = display == NeptuneIconLabel::TextUnderIcon
            ? iconImplicitHeight + textImplicitHeight + effectiveSpacing
            : qMax(iconImplicitHeight, textImplicitHeight);

    q->setImplicitSize(implicitWidth + horizontalPadding, implicitHeight + verticalPadding);
}

// adapted from QStyle::alignedRect()
static QRectF alignedRect(bool mirrored, Qt::Alignment alignment, const QSizeF &size,
                          const QRectF &rectangle)
{
    alignment = QGuiApplicationPrivate::visualAlignment(mirrored ? Qt::RightToLeft
                                                                 : Qt::LeftToRight, alignment);
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

void NeptuneIconLabelPrivate::applyIconSizeAndPosition(const QRectF &iconRect) {
    Q_ASSERT(image);

    // if we are using scaled image we have first to upscale and shift image item
    // according to iconScale (image.scale()), so when item is actually scaled, it will
    // be the iconRect size at iconRect.topLeft position
    // Do nothing in case of zero scale or 1.0 scale, just apply calculated iconRect
    if (image->scale() > 0 && !qFuzzyCompare(image->scale(), 1.0)) {
        image->setSize(iconRect.size() / image->scale());
        const QPointF shift{(image->size().width() - iconRect.size().width()) * 0.5,
                            (image->size().height() - iconRect.size().height()) * 0.5};
        image->setPosition(iconRect.topLeft() - shift);
    } else {
        // To avoid aliasing, apply only integer values for position
        // and size. Only valid for non-Pad mode
        image->setSize(iconRect.size().toSize());
        image->setPosition(iconRect.topLeft().toPoint());
    }
}

void NeptuneIconLabelPrivate::layout()
{
    // layout() is called to arrange image and text elements inside NeptuneIconLabel item
    //
    // We have:
    // 1. available area to fit
    // 2. pre-defined icon rect size for image of iconRectWidth x iconRectHeight
    // 3. fillMode
    // If fill mode is not Pad, then we are trying to fit image inside pre-defined icon rect
    // If pre-defined icon rect doesn't fit available size, min size is selected for resulting image
    // rect
    // If Pad mode is set, image is displayed according to defined iconScale multiplied by
    // (source image pixel size). With Pad set image will be sliced by NeptuneIconLabel item borders

    if (!componentComplete)
        return;

    const qreal availableWidth = width - leftPadding - rightPadding;
    const qreal availableHeight = height - topPadding - bottomPadding;

    // these sizes later compared to available item size, minimum is selected
    qreal iconWidth{iconRectWidth};
    qreal iconHeight{iconRectHeight};

    if (image && image->status() == QQuickImageBase::Ready && iconFillMode == QQuickImage::Pad) {
        // if Pad mode, use implicit size * iconScale
        // implicit size is set after image is loaded
        iconWidth = image->implicitWidth() * iconScale;
        iconHeight = image->implicitHeight() * iconScale;
    }

    switch (display) {
    case NeptuneIconLabel::IconOnly:
        if (image && image->status() == QQuickImageBase::Ready) {
            // Align rect for image according to available space
            const QRectF iconRect = alignedRect(mirrored, alignment,
                    QSizeF(qMin(iconWidth, availableWidth),
                        qMin(iconHeight, availableHeight)),
                    QRectF(leftPadding, topPadding, availableWidth, availableHeight));
            applyIconSizeAndPosition(iconRect);
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
        QSizeF iconSize{0.0, 0.0};
        QSizeF textSize{0.0, 0.0};
        if (image && image->status() == QQuickImageBase::Ready) {
            iconSize.setWidth(qMin(iconWidth, availableWidth));
            iconSize.setHeight(qMin(iconHeight, availableHeight));
        }
        qreal effectiveSpacing = 0;
        if (label) {
            if (!iconSize.isEmpty())
                effectiveSpacing = spacing;
            textSize.setWidth(qMin(label->implicitWidth(), availableWidth));
            textSize.setHeight(qMin(label->implicitHeight(),
                                    availableHeight - iconSize.height() - effectiveSpacing));
        }

        QRectF combinedRect = alignedRect(mirrored, alignment,
                            QSizeF(qMax(iconSize.width(), textSize.width()),
                            iconSize.height() + effectiveSpacing + textSize.height()),
                            QRectF(leftPadding, topPadding, availableWidth, availableHeight));
        if (image && image->status() == QQuickImageBase::Ready) {
            // Align rect for image according to available space
            QRectF iconRect = alignedRect(mirrored, Qt::AlignHCenter | Qt::AlignTop, iconSize,
                                          combinedRect);
            applyIconSizeAndPosition(iconRect);
        }
        if (label) {
            QRectF textRect = alignedRect(mirrored, Qt::AlignHCenter | Qt::AlignBottom, textSize,
                                          combinedRect);
            label->setSize(textRect.size());
            label->setPosition(textRect.topLeft());
        }
        break;
    }
    default:
        // includes case NeptuneIconLabel::TextBesideIcon:
        // Work out the sizes first, as the positions depend on them.
        QSizeF iconSize{0.0, 0.0};
        QSizeF textSize{0.0, 0.0};
        if (image && image->status() == QQuickImageBase::Ready) {
            iconSize.setWidth(qMin(iconWidth, availableWidth));
            iconSize.setHeight(qMin(iconHeight, availableHeight));
        }
        qreal effectiveSpacing = 0;
        if (label) {
            if (!iconSize.isEmpty())
                effectiveSpacing = spacing;
            textSize.setWidth(qMin(label->implicitWidth(),
                                   availableWidth - iconSize.width() - effectiveSpacing));
            textSize.setHeight(qMin(label->implicitHeight(), availableHeight));
        }

        const QRectF combinedRect = alignedRect(mirrored, alignment,
                                QSizeF(iconSize.width() + effectiveSpacing + textSize.width(),
                                qMax(iconSize.height(), textSize.height())),
                                QRectF(leftPadding, topPadding, availableWidth, availableHeight));
        if (image && image->status() == QQuickImageBase::Ready) {
            // Align rect for image according to available space
            const QRectF iconRect = alignedRect(mirrored, Qt::AlignLeft | Qt::AlignVCenter,
                                                iconSize, combinedRect);
            applyIconSizeAndPosition(iconRect);
        }
        if (label) {
            const QRectF textRect = alignedRect(mirrored, Qt::AlignRight | Qt::AlignVCenter,
                                                textSize, combinedRect);
            label->setSize(textRect.size());
            label->setPosition(textRect.topLeft().toPoint());
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

void NeptuneIconLabelPrivate::applyIconScaleForPadMode() {
    // works only for Pad fill mode (default)
    if (iconFillMode != QQuickImage::Pad)
        return;

    image->setScale(iconScale);
    updateImplicitSize();
    layout();
}

void NeptuneIconLabelPrivate::applyIconRect() {
    // works only for non-Pad fill mode
    if (iconFillMode == QQuickImage::Pad)
        return;

    // in non-pad mode scale is not used for image inner object, reset it
    // it is fitted inside desired rect
    if (!qFuzzyCompare(image->scale(), 1.0)) {
        image->setScale(1.0);
    }

    image->setFillMode(iconFillMode);
    updateImplicitSize();
    layout();
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
    if (qFuzzyCompare(d->iconScale, scale))
        return;

    if (qFuzzyCompare(scale, 0.0) || scale < 0.0) {
       qmlWarning(this) << "Invalid scale value: " << scale << "must be greater than zero";
       return;
    }

    d->iconScale = scale;
    if (d->image && d->image->status() == QQuickImageBase::Ready
            && d->iconFillMode == QQuickImage::Pad) {
        d->applyIconScaleForPadMode();
    }
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
    const Qt::Alignment align = (valign  ? static_cast<Qt::Alignment>(valign) : Qt::AlignVCenter)
            | (halign ? static_cast<Qt::Alignment>(valign) : Qt::AlignHCenter);
    if (d->alignment == align)
        return;

    d->alignment = align;
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

    //layout operates only by width and height, skip layout updates on rect x,y change
    if (newGeometry.size() != oldGeometry.size()) {
        d->layout();
    }
}

void NeptuneIconLabel::onImageStatusChanged(QQuickImageBase::Status status)
{
    Q_D(NeptuneIconLabel);

    if (status == QQuickImageBase::Ready) {
        // When we create image object we don't know about it's pixel size until it is loaded
        // We need image source pixel size to correctly display scaled image

        // In Pad mode we scale sourceSize according to iconScale size = pixel size x iconScale
        // In other modes we scale sourceSize to fit in desired iconRectWidth x iconRectHeight
        if (d->iconFillMode == QQuickImage::Pad) {
            d->applyIconScaleForPadMode();
        } else if (d->iconRectWidth > 0.0 && d->iconRectHeight > 0.0) {
            d->applyIconRect();
        }
    }
}

QQuickImage::FillMode NeptuneIconLabel::iconFillMode() const {
    Q_D(const NeptuneIconLabel);

    return d->iconFillMode;
}

void NeptuneIconLabel::setIconFillMode(QQuickImage::FillMode mode) {
    Q_D(NeptuneIconLabel);

    if (d->iconFillMode == mode)
        return;

    d->iconFillMode = mode;

    if (d->image && d->image->status() == QQuickImageBase::Ready) {
        if (d->iconFillMode == QQuickImage::Pad) {
            d->applyIconScaleForPadMode();
        } else if (d->iconRectWidth > 0 && d->iconRectHeight > 0) {
            d->applyIconRect();
        }
    }
}

void NeptuneIconLabel::setIconRectWidth(qreal width) {
    Q_D(NeptuneIconLabel);

    if (qFuzzyCompare(d->iconRectWidth, width))
        return;

    d->iconRectWidth = width;
    if (d->image && d->image->status() == QQuickImageBase::Ready && d->iconRectHeight > 0.0
            && d->iconFillMode != QQuickImage::Pad) {
        d->applyIconRect();
    }
    Q_EMIT iconRectWidthChanged();
}

void NeptuneIconLabel::setIconRectHeight(qreal height) {
    Q_D(NeptuneIconLabel);

    if (qFuzzyCompare(d->iconRectHeight, height))
        return;

    d->iconRectHeight = height;
    if (d->image && d->image->status() == QQuickImageBase::Ready && d->iconRectWidth > 0
            && d->iconFillMode != QQuickImage::Pad) {
        d->applyIconRect();
    }
    Q_EMIT iconRectHeightChanged();
}

qreal NeptuneIconLabel::iconRectWidth() const {
    Q_D(const NeptuneIconLabel);

    return d->iconRectWidth;
}

qreal NeptuneIconLabel::iconRectHeight() const {
    Q_D(const NeptuneIconLabel);

    return d->iconRectHeight;
}
QT_END_NAMESPACE
