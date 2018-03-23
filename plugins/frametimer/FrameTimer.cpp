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
#include "FrameTimer.h"

const qreal FrameTimer::MicrosInSec = qreal(1000 * 1000);

FrameTimer::FrameTimer(QObject *parent)
    : QObject(parent)
{
    m_updateTimer.setInterval(1000);
    connect(&m_updateTimer, &QTimer::timeout, this, &FrameTimer::calculateFramesPerSecond);
}

void FrameTimer::registerNewFrame()
{
    int frameTime = m_frameTimer.isValid() ? qMax(1, int(m_frameTimer.nsecsElapsed() / 1000)) : IdealFrameTime;
    m_frameTimer.restart();

    m_count++;
    m_sum += frameTime;
}

void FrameTimer::resetData()
{
    m_count = m_sum = 0;
    m_frameTimer.restart();
}

int FrameTimer::framesPerSecond() const
{
    return m_framesPerSecond;
}

void FrameTimer::setEnabled(bool value)
{
    if (m_enabled != value) {
        m_enabled = value;
        emit enabledChanged();

        updateTimer();
    }
}

void FrameTimer::setWindow(QQuickWindow *value)
{
    if (m_window != value) {
        if (m_window)
            disconnect(m_window, nullptr, this, nullptr);

        m_window = value;

        emit windowChanged();

        updateTimer();
    }
}

void FrameTimer::updateTimer()
{
    if (!m_window) {
        m_updateTimer.stop();
    } else if (m_enabled) {
        resetData();
        connect(m_window, &QQuickWindow::frameSwapped, this, &FrameTimer::registerNewFrame, Qt::UniqueConnection);
        m_updateTimer.start();
    } else {
        disconnect(m_window, nullptr, this, nullptr);
        m_updateTimer.stop();
    }
}

void FrameTimer::calculateFramesPerSecond()
{
    m_framesPerSecond = qRound(m_sum ? MicrosInSec * m_count / m_sum : qreal(0));

    // Start counting again for the next second but keep m_frameTimer running because
    // we still need the diff between the last rendered frame and the upcoming one.
    m_count = m_sum = 0;

    emit framesPerSecondChanged();
}
