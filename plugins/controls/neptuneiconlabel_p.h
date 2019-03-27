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

#ifndef NEPTUNEICONLABEL_P_H
#define NEPTUNEICONLABEL_P_H

#include <QtQuick/private/qquickitem_p.h>
#include <QtQuickControls2/private/qtquickcontrols2global_p.h>
#include <QtQuickTemplates2/private/qquickicon_p.h>

QT_BEGIN_NAMESPACE

class QQuickIconImage;
class QQuickMnemonicLabel;

class NeptuneIconLabelPrivate : public QQuickItemPrivate, public QQuickItemChangeListener
{
    Q_DECLARE_PUBLIC(NeptuneIconLabel)

public:
    explicit NeptuneIconLabelPrivate();

    bool hasIcon() const;
    bool hasText() const;

    bool createImage();
    bool destroyImage();
    bool updateImage();
    void syncImage();
    void updateOrSyncImage();

    bool createLabel();
    bool destroyLabel();
    bool updateLabel();
    void syncLabel();
    void updateOrSyncLabel();

    void updateImplicitSize();
    void layout();

    void watchChanges(QQuickItem *item);
    void unwatchChanges(QQuickItem *item);
    void setPositioningDirty();

    bool isLeftToRight() const;

    void itemImplicitWidthChanged(QQuickItem *) override;
    void itemImplicitHeightChanged(QQuickItem *) override;
    void itemDestroyed(QQuickItem *item) override;

    bool mirrored;
    NeptuneIconLabel::Display display;
    Qt::Alignment alignment;
    qreal spacing;
    qreal topPadding;
    qreal leftPadding;
    qreal rightPadding;
    qreal bottomPadding;
    qreal iconScale{1.0};
    QFont font;
    QColor color;
    QString text;
    QQuickIcon icon;
    QQuickIconImage *image;
    QQuickMnemonicLabel *label;
};

QT_END_NAMESPACE

#endif // NEPTUNEICONLABEL_P_H
