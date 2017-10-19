/****************************************************************************
**
** Copyright (C) 2016 Klarälvdalens Datakonsult AB, a KDAB Group company
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

import QtQuick 2.0
import QtQml.StateMachine 1.0 as DSM
import QtIvi.VehicleFunctions 1.0

QtObject {
    id: root
    property ClimateControl climateControl
    property bool doorsOpen: false

    property QtObject stateMachine: DSM.StateMachine {
        id: climateStateMachine
        running: true
        initialState: runningState

        DSM.State {
            childMode: DSM.State.ParallelStates
            id: runningState

            DSM.State {
                id: suspendable
                initialState: doorsClosedState

                DSM.State {
                    id: doorsClosedState
                    childMode: DSM.State.ParallelStates

                    DSM.State {
                        id: airConditionState
                        initialState: climateControl.airConditioningEnabled ? airConditionOn : airConditionOff

                        DSM.State {
                            id: airConditionOff
                            onEntered: climateControl.airConditioningEnabled = false
                            DSM.SignalTransition {
                                targetState: airConditionOn
                                signal: climateControl.airConditioningEnabledChanged
                                guard: climateControl.airConditioningEnabled
                            }
                        }

                        DSM.State {
                            id: airConditionOn
                            onEntered: {
                                climateControl.airConditioningEnabled = true
                                climateControl.steeringWheelHeater = 0
                            }
                            DSM.SignalTransition {
                                targetState: airConditionOff
                                signal: climateControl.airConditioningEnabledChanged
                                guard: !climateControl.airConditioningEnabled
                            }
                        }
                    } // airConditionState

                    DSM.State {
                        id: airRecirculationState
                        initialState: climateControl.recirculationEnabled ? airRecirculationOn : airRecirculationOff

                        DSM.State {
                            id: airRecirculationOff
                            onEntered: climateControl.recirculationMode = ClimateControl.RecirculationOff
                            DSM.SignalTransition {
                                targetState: airRecirculationOn
                                signal: climateControl.recirculationModeChanged
                                guard: climateControl.recirculationEnabled
                            }
                        }

                        DSM.State {
                            id: airRecirculationOn
                            onEntered: {
                                climateControl.recirculationMode = ClimateControl.RecirculationOn
                            }
                            DSM.SignalTransition {
                                targetState: airRecirculationOff
                                signal: climateControl.recirculationModeChanged
                                guard: climateControl.recirculationMode === ClimateControl.RecirculationOff
                            }
                        }
                    } // airRecirculationState

                    DSM.HistoryState {
                        id: historyState
                        defaultState: doorsClosedState
                        historyType: DSM.HistoryState.DeepHistory
                    }

                    DSM.SignalTransition {
                        targetState: suspended
                        signal: doorsOpenChanged
                        guard: doorsOpen
                    }
                } // door closed state

                DSM.State {
                    id: suspended
                    onEntered: {
                        climateControl.airConditioningEnabled = false
                        climateControl.recirculationMode = ClimateControl.RecirculationOff
                    }
                    DSM.SignalTransition {
                        targetState: historyState
                        signal: doorsOpenChanged
                        guard: !doorsOpen
                    }
                }

            } // suspendable state

            DSM.State {
                id: steeringWheelHeatState
                initialState: (climateControl.steeringWheelHeater >= 5) ? steeringWheelHeatOn : steeringWheelHeatOff

                DSM.State {
                    id: steeringWheelHeatOff
                    onEntered: climateControl.steeringWheelHeater = 0
                    DSM.SignalTransition {
                        targetState: steeringWheelHeatOn
                        signal: climateControl.steeringWheelHeaterChanged
                        guard: climateControl.steeringWheelHeater >= 5
                    }
                }

                DSM.State {
                    id: steeringWheelHeatOn
                    onEntered: {
                        climateControl.steeringWheelHeater = 10
                        climateControl.airConditioningEnabled = false
                    }
                    DSM.SignalTransition {
                        targetState: steeringWheelHeatOff
                        signal: climateControl.steeringWheelHeaterChanged
                        guard: climateControl.steeringWheelHeater < 5
                    }
                }
            }
        } // running state
    }
}
