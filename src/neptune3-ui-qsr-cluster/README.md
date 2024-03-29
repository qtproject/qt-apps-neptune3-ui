# Neptune 3 UI Safe UI

> This is a sample "safe part" implementation of Qt Safe Renderer (QSR) inside Neptune 3 project.
> It is based on desktop example from QSR sources and it's purpose is to enable development of QSR in desktop environment.
> This example is NOT implemented according Misra C++ 2008 nor ISO26262 functional safety standards and it depends on Qt classes.

In this sample main aspects of work with QSR are presented:

1. Loading layout generated from qml file inside Neptune 3 UI, which contains tell-tales, warning, speed and power texts
2. Interacting with QSR library for rendering into buffer via SafeWindow class inherited from QSR `AbstarctWindow` and basic QWindow
3. Using `StateManager` for controlling UI elements states
4. Communicating with `Non-Safe UI` with heartbeats and shut down processing
    Simple Qt TCP Sever (TcpMsgHandler) is used for this.
5. Communicating with Neptune's `Remote Settings Server` to get values of Safe UI elements states.
    Same QtIF autogenerated client is used as in Neptune's `Remote Control Application`

Application main work logic is:

* load generated layout
* create window and connect it to QSR `StateManager`
* start TCP server for processing heartbeats from `Non-Safe UI` and show warning if timeout or shutdown signal happens, hide them on new heartbeats
* start `Remote Settings Server` client to receive values for `Safe UI` elemets visibility states and text values

Desktop demo case:

On desktop it is possible to stick QSR window to Neptune's Cluster window to show that tell-tales are positioned and scaled the same.
It is enabled by default in settings file (`.config/Pelagicore/QSRCluster.conf`) key: `gui/stick_to_cluster`.
