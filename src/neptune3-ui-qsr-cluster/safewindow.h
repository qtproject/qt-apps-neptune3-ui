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

#ifndef SAFEWINDOW_H
#define SAFEWINDOW_H

#include <QtGui>
#include <QImage>

#include <QtSafeRenderer/qsaferenderer.h>
#include <QtSafeRenderer/qsafelayout.h>
#include <QtSafeRenderer/qsafewindow.h>

using namespace SafeRenderer;
QT_USE_NAMESPACE

class ScreenBuffer : public AbstractFrameBuffer
{
public:
    ScreenBuffer(const QSafeSize& size) :
        m_image(size.width(), size.height(), QImage::Format_RGBA8888) {

    }

    uchar *bits()
    {
        return m_image.bits();
    }

    quint32 bytesPerLine()
    {
        return m_image.bytesPerLine();
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

class SafeWindow : public QWindow, public AbstractWindow
{
    Q_OBJECT
public:
    explicit SafeWindow(const QSafeSize &size, const QSafeSize &frameSize, QWindow *parent = 0);

    virtual void render(QPainter *painter);

    //Window
    virtual void render(const Rect &dirtyArea);
    virtual AbstractFrameBuffer *buffer() {
        return &m_buffer;
    }

public slots:
    void renderLater();
    void renderNow();
    void moveWindow(quint32 x, quint32 y);

protected:
    bool event(QEvent *event) override;

    void resizeEvent(QResizeEvent *event) override;
    void exposeEvent(QExposeEvent *event) override;

private:
    QBackingStore *m_backingStore;
    ScreenBuffer   m_buffer;
    bool           m_transparent;
};

#endif // RASTERWINDOW_H
