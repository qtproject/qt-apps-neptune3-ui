/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

#include <QObject>

#include <QElapsedTimer>
#include <limits>
#include <QTimer>
#include <QQuickWindow>

/*
 Measures how many frames per second the given window is rendering

 Inspired by FrameTimer from qtapplicationmanager's monitor-lib

 */
class FrameTimer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QQuickWindow* window READ window WRITE setWindow NOTIFY windowChanged)
    Q_PROPERTY(int framesPerSecond READ framesPerSecond NOTIFY framesPerSecondChanged)
public:
    FrameTimer(QObject *parent = nullptr);

    int framesPerSecond() const;

    bool enabled() const { return m_enabled; }
    void setEnabled(bool);

    QQuickWindow *window() const { return m_window; }
    void setWindow(QQuickWindow *);

signals:
    void framesPerSecondChanged();
    void enabledChanged();
    void windowChanged();

private slots:
    void registerNewFrame();

private:
    void resetData();
    void updateTimer();
    void calculateFramesPerSecond();

    int m_count = 0;
    int m_sum = 0;

    QElapsedTimer m_frameTimer;

    int m_framesPerSecond = 0;

    QTimer m_updateTimer;

    bool m_enabled = false;
    QQuickWindow *m_window = nullptr;

    static const int IdealFrameTime = 16667; // usec - could be made configurable via an env variable
    static const qreal MicrosInSec;
};
