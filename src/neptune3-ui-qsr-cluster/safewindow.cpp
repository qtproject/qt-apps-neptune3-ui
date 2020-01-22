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

#include "safewindow.h"
#ifdef Q_OS_MACOS
    #include "safewindow_mac.h"
#endif

SafeWindow::SafeWindow(const SafeRenderer::QSafeSize &size, const SafeRenderer::QSafeSize &frameSize,
                       QWindow *parent)
    :QWindow(parent)
    ,AbstractWindow(size)
    ,m_buffer(frameSize)
{
    resize(size.width(), size.height());

    m_transparent = qgetenv("QSR_FILL_BLACK_BACKGROUND").isNull();

    //to run on KMS/DRM on NUC set transparent to false
    //otherwise nothing will be shown
    if (m_transparent) {
        #ifdef Q_OS_MACOS
            // Need to call native Obj-C method to make window
            // transparent om Mac QTBUG-77637
            SafeWindowMac::setWindowTransparent(reinterpret_cast<void*>(this->winId()));
        #endif
        QSurfaceFormat fmt = format();
        fmt.setAlphaBufferSize(8);
        setFormat(fmt);
    }

    create();
    m_backingStore = new QBackingStore(this);
}

bool SafeWindow::event(QEvent *event)
{
    if (event->type() == QEvent::UpdateRequest) {
        renderNow();
        return true;
    }
    return QWindow::event(event);
}

void SafeWindow::renderLater()
{
    requestUpdate();
}

void SafeWindow::resizeEvent(QResizeEvent *resizeEvent)
{
    m_backingStore->resize(resizeEvent->size());
    renderNow();
}

void SafeWindow::exposeEvent(QExposeEvent *)
{
    renderNow();
}

void SafeWindow::render(const SafeRenderer::Rect &dirtyArea)
{
    (void)dirtyArea;
    renderNow();
}

void SafeWindow::renderNow()
{
    if (!isExposed())
        return;

    QRect rect(0, 0, width(), height());
    m_backingStore->beginPaint(rect);

    QPaintDevice *device = m_backingStore->paintDevice();
    QPainter painter(device);
    if (!m_transparent) {
        painter.fillRect(rect, Qt::black);
    }
    render(&painter);
    painter.end();

    m_backingStore->endPaint();
    m_backingStore->flush(rect);
}

void SafeWindow::render(QPainter *painter)
{
    int x = (width() - m_buffer.image().width()) / 2;
    int y = (height() - m_buffer.image().height()) / 2;

    QRect rect(x, y, m_buffer.image().width(), m_buffer.image().height());
    painter->drawImage(rect,  m_buffer.image());
}

void SafeWindow::moveWindow(int x, int y)
{
    setWindowState(Qt::WindowNoState);
    setPosition(x, y);
    raise();
    requestActivate();
}

