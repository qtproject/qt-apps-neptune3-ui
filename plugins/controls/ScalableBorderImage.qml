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

import QtQuick 2.10

import shared.Sizes 1.0

/*!
    \qmltype ScalableBorderImage
    \inqmlmodule controls
    \inherits Item
    \since 5.11
    \brief The scalable border image component of Neptune 3.

    The ScalableBorderImage provides a BorderImage that scales according to Sizes.scale.
    It enables a BorderImage to stretch or shrink to support any pixel density.

    See \l{Neptune 3 UI Components and Interfaces} to see more available components in
    Neptune 3 UI.

    \section2 Example Usage

    The following example uses \l{ScalableBorderImage}:

    \qml
    import QtQuick 2.10
    import shared.controls 1.0

    Item {
        id: root

        ScalableBorderImage {
            id: topImage
            source: "app-fullscreen-top-bg"
        }
    }
    \endqml
*/

Item {
    id: root

    implicitWidth: Sizes.dp(borderImage.sourceSize.width)
    implicitHeight: Sizes.dp(borderImage.sourceSize.height)

    /*!
        \qmlproperty bool ScalableBorderImage::asynchronous

        Specifies that images on the local filesystem should be loaded asynchronously
        in a separate thread. The default value is false, causing the user interface
        thread to block while the image is loaded. Setting asynchronous to true is
        useful where maintaining a responsive user interface is more desirable than
        having images immediately visible.

        Note that this property is only valid for images read from the local filesystem.
        Images loaded via a network resource (e.g. HTTP) are always loaded asynchronously.
    */
    property alias asynchronous: borderImage.asynchronous

    /*!
        \qmlproperty var ScalableBorderImage::border

        This property holds the current selected index of the tools column.

        This property's default is 0.
    */
    property alias border: borderImage.border

    /*!
        \qmlproperty bool ScalableBorderImage::cache

        Specifies whether the image should be cached. The default value is true. Setting
        cache to false is useful when dealing with large images, to make sure that they
        aren't cached at the expense of small 'ui element' images.
    */
    property alias cache: borderImage.cache

    /*!
        \qmlproperty enumeration ScalableBorderImage::horizontalTileMode

        This property describes how to repeat or stretch the middle parts of the border
        image.
    */
    property alias horizontalTileMode: borderImage.horizontalTileMode

    /*!
        \qmlproperty bool ScalableBorderImage::mirror

        This property holds whether the image should be horizontally inverted (effectively
        displaying a mirrored image).

        This property's default is false.
    */
    property alias mirror: borderImage.mirror

    /*!
        \qmlproperty real ScalableBorderImage::progress

        This property holds the progress of image loading, from 0.0 (nothing loaded)
        to 1.0 (finished).
    */
    property alias progress: borderImage.progress

    /*!
        \qmlproperty bool ScalableBorderImage::smooth

        This property holds whether the image is smoothly filtered when scaled or
        transformed. Smooth filtering gives better visual quality, but it may be
        slower on some hardware. If the image is displayed at its natural size,
        this property has no visual or performance effect.

        By default, this property is set to true.
    */
    property alias smooth: borderImage.smooth

    /*!
        \qmlproperty url ScalableBorderImage::source

        This property holds the URL that refers to the source image.

        BorderImage can handle any image format supported by Qt, loaded from any
        URL scheme supported by Qt.

        This property can also be used to refer to .sci files, which are written
        in a QML-specific, text-based format that specifies the borders, the image
        file and the tile rules for a given border image.
    */
    property alias source: borderImage.source

    /*!
        \qmlproperty QSize ScalableBorderImage::sourceSize

        This property holds the actual width and height of the loaded image.
    */
    property alias sourceSize: borderImage.sourceSize

    /*!
        \qmlproperty enumeration ScalableBorderImage::status

        This property describes the status of image loading. It can be one of:

        \list
        \li BorderImage.Null - no image has been set
        \li BorderImage.Ready - the image has been loaded
        \li BorderImage.Loading - the image is currently being loaded
        \li BorderImage.Error - an error occurred while loading the image
        \endlist
    */
    property alias status: borderImage.status

    /*!
        \qmlproperty enumeration ScalableBorderImage::verticalTileMode

        This property describes how to repeat or stretch the middle parts of the
        border image.

        \list
        \li BorderImage.Stretch - Scales the image to fit to the available area.
        \li BorderImage.Repeat - Tile the image until there is no more space. May crop the last image.
        \li BorderImage.Round - Like Repeat, but scales the images down to ensure that the last image is not cropped.
        \endlist
    */
    property alias verticalTileMode: borderImage.verticalTileMode

    BorderImage {
        id: borderImage
        width: root.width / Sizes.scale
        height: root.height / Sizes.scale
        scale: Sizes.scale
        transformOrigin: Item.TopLeft
    }
}
