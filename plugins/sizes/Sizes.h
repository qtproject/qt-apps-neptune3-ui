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

#include <QtCore/QSharedPointer>
#include <QtCore/QScopedPointer>
#include <QJSValue>

#include <QtQuickControls2/private/qquickattachedobject_p.h>

class StyleData;

class Sizes : public QQuickAttachedObject
{
    Q_OBJECT

    // Font sizes are already premultiplied by Sizes::scale
    Q_PROPERTY(int fontSizeXXS READ fontSizeXXS NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeXS READ fontSizeXS NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeS READ fontSizeS NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeM READ fontSizeM NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeL READ fontSizeL NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeXL READ fontSizeXL NOTIFY scaleChanged FINAL)
    Q_PROPERTY(int fontSizeXXL READ fontSizeXXL NOTIFY scaleChanged FINAL)

    /*
        Scale factor to be applied to pixel values

        Neptune 3 UI was designed for a specific aspect ratio, physical size and DPI.
        In order to support other pixel densities this scale factor has to be applied to all
        pixel values (ie, pixel values have to be multiplied by it), preferably via
        the Sizes.dp() function.

        \sa dp
     */
    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY scaleChanged)

    /*
        Converts pixels values from the reference pixel density to the current one

        Applies the current scale factor to the given pixel value, effectively
        converting it into device pixels (dp). It might also round it up to the
        nearest integer to minimize aliasing artifacts.

        \sa scale
     */
    Q_PROPERTY(QJSValue dp READ dp NOTIFY scaleChanged)

public:
    explicit Sizes(QObject *parent = nullptr);
    virtual ~Sizes();

    static Sizes *qmlAttachedProperties(QObject *object);

    int fontSizeXXS() const;
    int fontSizeXS() const;
    int fontSizeS() const;
    int fontSizeM() const;
    int fontSizeL() const;
    int fontSizeXL() const;
    int fontSizeXXL() const;

    qreal scale() const;
    void setScale(qreal);

    QJSValue dp() const;

protected:
    void init();
signals:
    void scaleChanged();

private:
    QScopedPointer<StyleData> m_data;
    mutable QJSValue m_dp;

protected:
    void attachedParentChange(QQuickAttachedObject *newParent, QQuickAttachedObject *oldParent) override;
    void inheritStyle(const StyleData &data);
    void propagateStyle(const StyleData &data);
    void propagateScale();
};

QML_DECLARE_TYPEINFO(Sizes, QML_HAS_ATTACHED_PROPERTIES)
