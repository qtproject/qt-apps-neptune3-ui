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

#pragma once

#include <QtGlobal>
#include <QObject>
#include <QTouchEvent>
#include <QMouseEvent>
#include <QQmlEngine>

#include <QDebug>
class TouchPointsTracer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QObject *target READ getTarget WRITE setTarget)
public:
    explicit TouchPointsTracer(QObject *parent = nullptr) :
        QObject(parent)
        , m_filterTouches(!qgetenv("SHOW_TOUCH_POINTS").compare(QByteArrayLiteral("yes")))
    {}

    static TouchPointsTracer *qmlAttachedProperties(QObject *object) {
        return new TouchPointsTracer(object);
    }

    QObject *getTarget() const {
        return m_currentTarget;
    }

    void setTarget(QObject *target) {
        if (m_currentTarget) {
            removeEventFilter(m_currentTarget);
        }

        m_currentTarget = target;
        listenTo(target);
    }

    bool eventFilter(QObject *object, QEvent *event) override {
        if (m_filterTouches) {
            if (event->type() == QEvent::TouchBegin
                    || event->type() == QEvent::TouchEnd
                    || event->type() == QEvent::TouchUpdate) {
                auto tEvent = static_cast<QTouchEvent *>(event);
                const QList<QTouchEvent::TouchPoint> touchPoints = tEvent->touchPoints();
                QVector<int> points;
                points.reserve(touchPoints.size() * 2); // 2 int = point
                for (auto && tp : touchPoints) {
                    QPoint point = tp.pos().toPoint();
                    points << point.x() << point.y();
                }

                if (!points.isEmpty())
                    emit touchPointsChanged(object, points);
            } else if (event->type() == QEvent::MouseButtonPress
                       || event->type() == QEvent::MouseButtonRelease
                       || event->type() == QEvent::MouseMove)
            {
                auto mouseEvent = static_cast<QMouseEvent *>(event);
                if (mouseEvent->buttons()) {
                    emit touchPointsChanged(object, {mouseEvent->pos().x(), mouseEvent->pos().y()});
                }
            }
        }

        return false;
    }

signals:
    // QVector<int> is transparently supported by qml, we are trying to reduce data conversions
    void touchPointsChanged(QObject *object, QVector<int> points);

private:
    QObject* m_currentTarget{nullptr};
    bool m_filterTouches{false};

    void listenTo(QObject *object) {
        if (!object || !m_filterTouches)
            return;

        object->installEventFilter(this);
    }
};

QML_DECLARE_TYPEINFO(TouchPointsTracer, QML_HAS_ATTACHED_PROPERTIES)
