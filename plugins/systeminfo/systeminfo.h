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

#ifndef SYSTEMINFO_H
#define SYSTEMINFO_H

#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <QtQml/QQmlParserStatus>
#include <QProcess>
#include <QVariant>
#include <QNetworkAccessManager>

class SystemInfo : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QStringList addressList READ addressList NOTIFY addressListChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(bool internetAccess READ internetAccess NOTIFY internetAccessChanged)
    Q_PROPERTY(QString productName READ productName CONSTANT)
    Q_PROPERTY(QString cpu READ cpu CONSTANT)
    Q_PROPERTY(QString kernel READ kernel CONSTANT)
    Q_PROPERTY(QString kernelVersion READ kernelVersion CONSTANT)
    Q_PROPERTY(QString qtVersion READ qtVersion CONSTANT)
    Q_PROPERTY(QString qtDiag READ qtDiag NOTIFY qtDiagChanged)
    Q_PROPERTY(bool allow3dStudioPresentations READ allow3dStudioPresentations CONSTANT)
    Q_PROPERTY(bool allowOpenGLContent READ allowOpenGLContent CONSTANT)

public:
    explicit SystemInfo(QObject *parent = nullptr);
    ~SystemInfo() override;
    QStringList addressList() const;
    bool internetAccess() const;
    bool connected() const;
    QString qtVersion() const;
    QString productName() const;
    QString cpu() const;
    QString kernel() const;
    QString kernelVersion() const;
    QString qtDiag() const;

    Q_INVOKABLE QVariant readEnvironmentVariable(const QString &name) const;
    Q_INVOKABLE bool isEnvironmentVariableSet(const QString &name) const;
    Q_INVOKABLE bool isEnvironmentVariableEmpty(const QString &name) const;

public slots:
    void init();

signals:
    void addressListChanged();
    void internetAccessChanged();
    void connectedChanged();
    void qtDiagChanged();

protected:
    void classBegin() override;
    void componentComplete() override;
    void timerEvent(QTimerEvent *event) override;

private slots:
    void updateConnectedStatus(bool status);
    void updateInternetAccessStatus(bool status);
    void replyFinished(QNetworkReply *reply);

private:
    void getAddress();
    void getQtDiagInfo();
    bool allow3dStudioPresentations();
    bool allowOpenGLContent();

    QStringList m_addressList;
    int m_timerId{0};
    bool m_connected{false};
    bool m_internetAccess{false};
    QString m_qtDiagContents;
    QNetworkAccessManager *m_networkManager = nullptr;
#if QT_CONFIG(process)
    QProcess *m_diagProc{nullptr};
#endif
};

#endif // SYSTEMINFO_H
