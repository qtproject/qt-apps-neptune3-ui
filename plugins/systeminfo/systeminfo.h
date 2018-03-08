/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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

#ifndef SYSTEMINFO_H
#define SYSTEMINFO_H

#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <QtQml/QQmlParserStatus>

class SystemInfo : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QStringList addressList READ addressList NOTIFY addressListChanged)
    Q_PROPERTY(bool online READ online NOTIFY onlineChanged)
    Q_PROPERTY(QString qtVersion READ qtVersion CONSTANT)

public:
    explicit SystemInfo(QObject *parent = nullptr);
    QStringList addressList() const;
    bool online() const;
    QString qtVersion() const;

public slots:
    void init();

signals:
    void addressListChanged();
    void onlineChanged();

protected:
    void classBegin() override;
    void componentComplete() override;

private slots:
    void updateOnlineStatus(quint32 state);

private:
    void getAddress();
    QStringList m_addressList;
    bool m_online{false};
};

#endif // SYSTEMINFO_H
