/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
#ifndef UISETTINGSDYNAMIC_H
#define UISETTINGSDYNAMIC_H

#include "abstractdynamic.h"

class UISettingsDynamic : public AbstractDynamic
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QVariantList languages READ languages NOTIFY languagesChanged)
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(qreal balance READ balance WRITE setBalance NOTIFY balanceChanged)
    Q_PROPERTY(int theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(bool door1Open READ door1Open WRITE setDoor1Open NOTIFY door1OpenChanged)
    Q_PROPERTY(bool door2Open READ door2Open WRITE setDoor2Open NOTIFY door2OpenChanged)
public:
    UISettingsDynamic();

    QString language() const;
    QVariantList languages() const;
    qreal volume() const;
    bool muted() const;
    qreal balance() const;
    int theme() const;
    bool door1Open() const;
    bool door2Open() const;

    void initialize() override;

public Q_SLOTS:
    void setLanguage(const QString &language);
    void setVolume(qreal volume);
    void setMuted(bool muted);
    void setBalance(qreal balance);
    void setTheme(int theme);
    void setDoor1Open(bool door1Open);
    void setDoor2Open(bool door2Open);

Q_SIGNALS:
    void languageChanged(const QString &language);
    void languagesChanged(const QVariantList &languages);
    void volumeChanged(qreal);
    void mutedChanged(bool);
    void balanceChanged(qreal);
    void themeChanged(int);
    void door1OpenChanged(bool);
    void door2OpenChanged(bool);
};

#endif // UISETTINGSDYNAMIC_H
