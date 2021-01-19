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

SafeWindow::SafeWindow(const SafeRenderer::QSafeSize &size,
                       const SafeRenderer::QSafeSize &frameSize, bool stickToCluster,
                       QWindow *parent)
    :QWindow(parent)
    ,AbstractWindow(size)
    ,m_buffer(frameSize)
    ,m_transparent(qgetenv("QSR_FILL_BLACK_BACKGROUND").isNull())
    ,m_stickToCluster(stickToCluster)
{
    resize(size.width(), size.height());

    if (m_stickToCluster) {
        #ifdef Q_OS_LINUX
        // KDE desktop runs Plasma, which doesn't allow in our case rise qsr window,
        // that's why qsr window stays under non-safe UI window.
        // For KDE we set for window stay-on-top flag which solves described issue.
        // Interacting without this flag is a bit more comfortable, so we leave it for other
        // environments
        const QString desktopEnvironment = QString(qgetenv("DESKTOP_SESSION")).toLower();
        if (desktopEnvironment.contains(QStringLiteral("plasma"))
            || desktopEnvironment.contains(QStringLiteral("kde"))) {
            setFlag(Qt::WindowStaysOnTopHint);
        }
        #endif

        // Desktop demo case: center on the screen on start
        setPosition(qApp->primaryScreen()->availableGeometry().x()
                    + (qApp->primaryScreen()->availableGeometry().width() - size.width()) / 2,
                    qApp->primaryScreen()->availableGeometry().y()
                    + (qApp->primaryScreen()->availableGeometry().height() - size.height()) / 2);
    }

    //to run on KMS/DRM on NUC set transparent to false
    //otherwise nothing will be shown
    if (m_transparent) {
        #ifdef Q_OS_MACOS
            // Need to call native Obj-C method to make window
            // transparent om Mac QTBUG-77637
            SafeWindowMac::setWindowTransparent(reinterpret_cast<void*>(this->winId()));
        #endif
        #ifdef Q_OS_WIN32
                // QWindow doesn't allow making window background transparent on Windows,
                // we have to use native calls to set black color as transparent.
                // We make window stay on top as rise() function doesn't work as it does on
                // macOS and Linux platforms (still remains under cluster window)
                this->setFlag(Qt::WindowStaysOnTopHint);
                this->setFlag(Qt::WindowTitleHint);
                this->setFlag(Qt::WindowSystemMenuHint);
                this->setFlag(Qt::WindowCloseButtonHint);

                HWND hwnd = reinterpret_cast<HWND>(this->winId());
                SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) | WS_EX_LAYERED);
                SetLayeredWindowAttributes(hwnd, 0, 0, LWA_COLORKEY);
        #endif

        QSurfaceFormat fmt = format();
        fmt.setAlphaBufferSize(8);
        setFormat(fmt);
    }

    create();
    m_backingStore = new QBackingStore(this);
}

bool SafeWindow::isRunningOnDesktop() {
#if defined(Q_OS_WIN) || defined(Q_OS_MACOS)
    return true;
#else
    return qApp->platformName() == QStringLiteral("xcb");
#endif
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
    Q_UNUSED(dirtyArea)
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
    if (m_stickToCluster) {
        // Desktop demo case: fit frame to window
        QRect rect(0, 0, width(), height());
        painter->setRenderHint(QPainter::SmoothPixmapTransform, true);
        painter->drawImage(rect,  m_buffer.image(), m_buffer.image().rect());
    } else {
        // Center qsr rendered frame inside window
        int x = (width() - m_buffer.image().width()) / 2;
        int y = (height() - m_buffer.image().height()) / 2;

        QRect rect(x, y, m_buffer.image().width(), m_buffer.image().height());
        painter->drawImage(rect,  m_buffer.image());
    }
}

void SafeWindow::moveWindow(int x, int y)
{
    m_rootWindowX = x;
    m_rootWindowY = y;

    setWindowState(Qt::WindowNoState);
    setPosition(m_rootWindowX + m_panelOriginX, m_rootWindowY + m_panelOriginY);
    raise();
    requestActivate();
}

void SafeWindow::resizeWindow(int width, int height)
{
    if (width <= 0 || height <= 0)
        return;

    setWindowState(Qt::WindowNoState);
    resize(width, height);
    raise();
    requestActivate();
}

void SafeWindow::applyPanelOrigin(int dx, int dy)
{
    m_panelOriginX = dx;
    m_panelOriginY = dy;

    setWindowState(Qt::WindowNoState);
    setPosition(m_rootWindowX + m_panelOriginX, m_rootWindowY + m_panelOriginY);
    raise();
    requestActivate();
}

SafeRenderer::AbstractFrameBuffer *SafeWindow::buffer()
{
    return &m_buffer;
}
