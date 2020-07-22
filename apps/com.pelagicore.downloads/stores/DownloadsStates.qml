/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
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

import QtQuick 2.8
import QtQml.StateMachine 1.0 as DSM

import "JSONBackend.js" as JSONBackend
import shared.com.pelagicore.systeminfo 1.0
import shared.utils 1.0

DSM.StateMachine {
    running: true
    initialState: networkConnectedState

    property alias noNetwork: noNetworkState
    property alias networkConnected: networkConnectedState
    property alias connectingToServer: connectingToServerState
    property alias connectedError: connectedErrorState
    property alias connectedToServer: connectedToServerState
    property alias fetchingApps: fetchingAppsState
    property alias fetchingCategories: fetchingCategoriesState
    property alias appsLoaded: appsLoadedState
    property alias serverOnMaintance: serverOnMaintanceState
    property alias serverNA: serverNAState
    property alias loggingIn: loggingInState
    property alias categoriesLoaded: categoriesLoadedState
    property alias checkServerError: checkServerErrorState

    property SystemInfo sysinfo
    property ServerConfig appStoreConfig
    property JSONModel jsonCategoryModel
    property JSONModel jsonAppModel

    DSM.State {
        id: noNetworkState

        DSM.SignalTransition {
            targetState: networkConnectedState
            signal: sysinfo.onInternetAccessChanged
            guard: sysinfo.internetAccess
        }

        DSM.SignalTransition {
            targetState: networkConnectedState
            signal: sysinfo.onConnectedChanged
            guard: sysinfo.connected
        }
    }

    DSM.State {
        id: networkConnectedState

        initialState: connectingToServerState
        onEntered: { appStoreConfig.reconnectionAttempt = 0; }

        DSM.SignalTransition {
            targetState: noNetworkState
            signal: sysinfo.onConnectedChanged
            guard: !sysinfo.connected
        }

        DSM.SignalTransition {
            targetState: noNetworkState
            signal: sysinfo.onInternetAccessChanged
            guard: !sysinfo.internetAccess
        }

        DSM.State {
            id: connectingToServerState

            DSM.SignalTransition {
                targetState: connectedToServerState
                signal: appStoreConfig.connectionSuccessful
            }
            DSM.SignalTransition {
                targetState: checkServerErrorState
                signal: appStoreConfig.connectionFailed
            }
            DSM.SignalTransition {
                targetState: serverOnMaintanceState
                signal: appStoreConfig.serverOnMaintanceState
            }
        }

        DSM.State {
            id: serverOnMaintanceState

            DSM.SignalTransition {
                targetState: connectingToServerState
                signal: appStoreConfig.tryConnectToServer
            }
        }

        DSM.State {
            id: checkServerErrorState

            signal noMoreAttempts()

            onEntered: {
                if (appStoreConfig.reconnectionAttempt < appStoreConfig.maxReconnectCount) {
                    appStoreConfig.reconnectionAttempt += 1;
                    retryTimer.start();
                } else {
                    noMoreAttempts();
                }
            }

            Timer {
                id: retryTimer
                interval: 2000
                onTriggered: {
                    console.warn(Logging.apps, "Neptune 3 UI::DownloadsStates - Retry Connection",
                                 appStoreConfig.reconnectionAttempt, "of",
                                 appStoreConfig.maxReconnectCount);
                    appStoreConfig.checkServer();
                }
            }

            DSM.SignalTransition {
                targetState: connectingToServerState
                signal: appStoreConfig.tryConnectToServer
            }

            DSM.SignalTransition {
                targetState: serverNAState
                signal: checkServerErrorState.noMoreAttempts
            }
        }

        DSM.State {
            id: serverNAState

            onEntered: { appStoreConfig.reconnectionAttempt = 0; }

            DSM.SignalTransition {
                targetState: connectingToServerState
                signal: appStoreConfig.tryConnectToServer
            }
        }

        DSM.State {
            id: connectedToServerState

            initialState: loggingInState
            onEntered: { appStoreConfig.reconnectionAttempt = 0; }

            DSM.SignalTransition {
                targetState: checkServerErrorState
                signal: appStoreConfig.connectionFailed
            }

            DSM.State {
                id: loggingInState

                onEntered: { appStoreConfig.login(); }

                Connections {
                    target: appStoreConfig
                    function onLoginFailed() {
                        connectedErrorState.errorText = qsTr("Login Failed");
                    }
                }

                DSM.SignalTransition {
                    targetState: connectedErrorState
                    signal: appStoreConfig.loginFailed
                }

                DSM.SignalTransition {
                    targetState: loggedInState
                    signal: appStoreConfig.loginSuccessful
                }
            }

            DSM.State {
                id: connectedErrorState

                property string errorText: ""

                DSM.SignalTransition {
                    targetState: connectingToServerState
                    signal: appStoreConfig.tryConnectToServer
                }
            }

            DSM.State {
                id: loggedInState

                initialState: fetchingCategoriesState

                DSM.State {
                    id: fetchingCategoriesState

                    onEntered: { jsonCategoryModel.refresh(); }

                    Connections {
                        target: jsonCategoryModel
                        function onStatusChanged() {
                            if (jsonCategoryModel.status === "error")
                                connectedErrorState.errorText = qsTr("Fetching categories error");
                        }
                    }

                    DSM.SignalTransition {
                        targetState: categoriesLoadedState
                        signal: jsonCategoryModel.onStatusChanged
                        guard: jsonCategoryModel.status === "ready"
                    }

                    DSM.SignalTransition {
                        targetState: connectedErrorState
                        signal: jsonCategoryModel.onStatusChanged
                        guard: jsonCategoryModel.status === "error"
                    }
                }

                DSM.State {
                    id: categoriesLoadedState

                    onEntered: {
                        if (jsonCategoryModel.count > 0) {
                            jsonAppModel.categoryId = jsonCategoryModel.get(0).id;
                            jsonAppModel.refresh()
                        } else {
                            jsonCategoryModel.emptyCategoriesList()
                        }
                    }

                    DSM.SignalTransition {
                        targetState: fetchingAppsState
                        signal: jsonAppModel.onStatusChanged
                        guard: jsonAppModel.status === "loading"
                    }

                    DSM.SignalTransition {
                        targetState: appsLoadedState
                        signal: jsonAppModel.onStatusChanged
                        guard: jsonAppModel.status === "ready"
                    }

                    DSM.SignalTransition {
                        targetState: appsLoadedState
                        signal: jsonCategoryModel.onEmptyCategoriesList
                    }
                }

                DSM.State {
                    id: fetchingAppsState

                    Connections {
                        target: jsonAppModel
                        function onStatusChanged() {
                            if (jsonAppModel.status === "error")
                                connectedErrorState.errorText = qsTr("Fetching apps error");
                        }
                    }

                    DSM.SignalTransition {
                        targetState: appsLoadedState
                        signal: jsonAppModel.onStatusChanged
                        guard: jsonAppModel.status === "ready"
                    }

                    DSM.SignalTransition {
                        targetState: connectedErrorState
                        signal: jsonAppModel.onStatusChanged
                        guard: jsonAppModel.status === "error"
                    }
                }

                DSM.State {
                    id: appsLoadedState

                    DSM.SignalTransition {
                        targetState: fetchingAppsState
                        signal: jsonAppModel.onStatusChanged
                        guard: jsonAppModel.status === "loading"
                    }

                    DSM.SignalTransition {
                        targetState: fetchingCategoriesState
                        signal: jsonCategoryModel.onStatusChanged
                        guard: jsonCategoryModel.status === "loading"
                    }
                }
            }
        }
    }
}
