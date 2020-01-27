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

#ifndef SAFEWINDOW_H
#define SAFEWINDOW_H

#include <QtGui>
#include <QImage>

#include <QtSafeRenderer/qsaferenderer.h>
#include <QtSafeRenderer/qsafelayout.h>
#include <QtSafeRenderer/qsafewindow.h>

QT_USE_NAMESPACE

class ScreenBuffer : public SafeRenderer::AbstractFrameBuffer
{
public:
    ScreenBuffer(const SafeRenderer::QSafeSize& size) :
        m_image(size.width(), size.height(), QImage::Format_RGBA8888) {

    }

    uchar *bits()
    {
        return m_image.bits();
    }

    SafeRenderer::quint32 bytesPerLine()
    {
        return static_cast<SafeRenderer::quint32>(m_image.bytesPerLine());
    }

    QImage image()
    {
        return m_image;
    }

    uchar bitsPerPixel()
    {
        return m_image.pixelFormat().bitsPerPixel();
    }

    PixelFormat format() const
    {
        return PixelFormat::RGBA8888;
    }

private:
    QImage m_image;
};

class SafeWindow : public QWindow, public SafeRenderer::AbstractWindow
{
    Q_OBJECT
public:
    SafeWindow(const SafeRenderer::QSafeSize &size,
                        const SafeRenderer::QSafeSize &frameSize,
                        bool stickToCluster, QWindow *parent = 0);

    virtual void render(QPainter *painter);

    //Window
    virtual void render(const SafeRenderer::Rect &dirtyArea) override;
    virtual SafeRenderer::AbstractFrameBuffer *buffer() override;

    // Copies behavior of QtApplicationManager to decide if we are running on Desktop
    static bool isRunningOnDesktop();

public slots:
    void renderLater();
    void renderNow();
    // Apply cluster widow position
    // Used when running on Desktop
    void moveWindow(int x, int y);
    // Apply cluster panel width and height to window size
    // Used when running on Desktop
    void resizeWindow(int width, int weight);
    // Apply cluster panel position inside cluster window
    // Used when running on desktop
    void applyPanelOrigin(int dx, int dy);

protected:
    bool event(QEvent *event) override;

    void resizeEvent(QResizeEvent *event) override;
    void exposeEvent(QExposeEvent *event) override;

private:
    QBackingStore *m_backingStore;
    ScreenBuffer   m_buffer;
    bool           m_transparent;
    int            m_rootWindowX{0};
    int            m_rootWindowY{0};
    int            m_panelOriginX{0};
    int            m_panelOriginY{0};
    bool           m_stickToCluster;
};
#endif // SAFEWINDOW_H
