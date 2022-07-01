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

#ifndef NEPTUNEICONLABEL_H
#define NEPTUNEICONLABEL_H

#include <QtQuick/qquickitem.h>
#include <QtQuickTemplates2/private/qquickicon_p.h>
#include <QtQuick/private/qquickimagebase_p.h>
#include <QtQuick/private/qquickimage_p.h>

QT_BEGIN_NAMESPACE

class NeptuneIconLabelPrivate;

class NeptuneIconLabel : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QQuickIcon icon READ icon WRITE setIcon FINAL)
    Q_PROPERTY(qreal iconScale READ iconScale WRITE setIconScale FINAL)
    Q_PROPERTY(QString text READ text WRITE setText FINAL)
    Q_PROPERTY(QFont font READ font WRITE setFont FINAL)
    Q_PROPERTY(QColor color READ color WRITE setColor FINAL)
    Q_PROPERTY(Display display READ display WRITE setDisplay FINAL)
    Q_PROPERTY(qreal spacing READ spacing WRITE setSpacing FINAL)
    Q_PROPERTY(bool mirrored READ isMirrored WRITE setMirrored FINAL)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment FINAL)
    Q_PROPERTY(qreal topPadding READ topPadding WRITE setTopPadding RESET resetTopPadding FINAL)
    Q_PROPERTY(qreal leftPadding READ leftPadding WRITE setLeftPadding RESET resetLeftPadding FINAL)
    Q_PROPERTY(qreal rightPadding READ rightPadding WRITE setRightPadding RESET resetRightPadding FINAL)
    Q_PROPERTY(qreal bottomPadding READ bottomPadding WRITE setBottomPadding RESET resetBottomPadding FINAL)
    Q_PROPERTY(QQuickImage::FillMode iconFillMode READ iconFillMode WRITE setIconFillMode FINAL)
    Q_PROPERTY(qreal iconRectWidth READ iconRectWidth WRITE setIconRectWidth
               NOTIFY iconRectWidthChanged)
    Q_PROPERTY(qreal iconRectHeight READ iconRectHeight WRITE setIconRectHeight
               NOTIFY iconRectHeightChanged)

public:
    enum Display {
        IconOnly,
        TextOnly,
        TextBesideIcon,
        TextUnderIcon
    };
    Q_ENUM(Display)

    explicit NeptuneIconLabel(QQuickItem *parent = nullptr);
    ~NeptuneIconLabel();

    QQuickImage::FillMode iconFillMode() const;
    void setIconFillMode(QQuickImage::FillMode mode);

    QQuickIcon icon() const;
    void setIcon(const QQuickIcon &icon);

    qreal iconScale() const;
    void setIconScale(qreal scale);

    QString text() const;
    void setText(const QString text);

    QFont font() const;
    void setFont(const QFont &font);

    QColor color() const;
    void setColor(const QColor &color);

    Display display() const;
    void setDisplay(Display display);

    qreal spacing() const;
    void setSpacing(qreal spacing);

    bool isMirrored() const;
    void setMirrored(bool mirrored);

    Qt::Alignment alignment() const;
    void setAlignment(Qt::Alignment alignment);

    qreal topPadding() const;
    void setTopPadding(qreal padding);
    void resetTopPadding();

    qreal leftPadding() const;
    void setLeftPadding(qreal padding);
    void resetLeftPadding();

    qreal rightPadding() const;
    void setRightPadding(qreal padding);
    void resetRightPadding();

    qreal bottomPadding() const;
    void setBottomPadding(qreal padding);
    void resetBottomPadding();

    qreal iconRectWidth() const;
    void setIconRectWidth(qreal width);

    qreal iconRectHeight() const;
    void setIconRectHeight(qreal height);

Q_SIGNALS:
    void iconRectWidthChanged();
    void iconRectHeightChanged();

protected:
    void componentComplete() override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;

private Q_SLOTS:
    void onImageStatusChanged(QQuickImageBase::Status);

private:
    Q_DISABLE_COPY(NeptuneIconLabel)
    Q_DECLARE_PRIVATE(NeptuneIconLabel)
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(NeptuneIconLabel)

#endif // NEPTUNEICONLABEL_H
