# Neptune 3 UI

Neptune 3 is a reference implementation of a multiprocess System UI using Qt Automotive Suite.

You can easily fetch, build and install it along with all its dependencies using the qtauto-admin tool which can be found here:
https://gitlab.com/jryannel/qauto-admin

Otherwise you can read on for information on how to fetch its dependencies and build it yourself.

## Prerequisites and dependencies

### Multi-process UI (preferred)

When in multi process mode, application run as independent processes, as wayland clients,
and the System UI acts as a wayland server, compositing the application windows in its own
QML scene, as regular QML items.

* Linux (e.g. Ubuntu 16.04)
* Qt5 (branch 5.13) with qtwayland submodule and built with Open GL ES (-opengl es2 -opengles3)
* QtIvi (git://code.qt.io/qt/qtivi.git, branch 5.13)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch 5.13)

### Single-process UI (fallback option)

When in single process mode, all application code run in the same QML scene and
process as the System UI itself.

* Linux (e.g. Ubuntu 16.04) or macOS
* Qt5 (branch 5.13)
* QtIvi (git://code.qt.io/qt/qtivi.git, branch 5.13)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch 5.13)

## Clone Repository

The repo uses git-lfs. You need to install [https://git-lfs.github.com/](git-lfs) first. To not enter every time the credentials you can use the git credential cache. The GitLab server uses a self-signed certification, so we need to override the ssl verification.

Here are the commands:

    $ git lfs install
    $ git clone git://code.qt.io/qt-apps/neptune3-ui.git
    $ cd neptune3-ui
    $ git config credential.helper cache
    $ git config http.sslverify false

## Build and install neptune3-ui

    $ qmake --version

This should report a Qt 5.12 version

    $ qmake INSTALL_PREFIX=/path/to/install/folder && make && make install

This will install all qml files and plugins into the neptune subfolder of '/path/to/install/folder'. If INSTALL_PREFIX is not defined, then this will build all neptune3-ui plugins and installs the complete neptune3-ui to /opt/neptune3 folder.

You should have the Open Sans font installed in your system (see the ttf files in imports/assets/fonts). Its installation is *not* being done automatically.

The installation part is optional.

* (Optional) Run scripts within the plugins/scripts folder to scan the media on the system

## Run entire UI

Building Neptune will make 'neptune3-ui' executable which will be then run:

    $ neptune3-ui --start-session-dbus -r

To get more detailed log output, run:

    $ neptune3-ui --start-session-dbus -r --verbose

*macOS Fix*: The RPATh feature is not currently working and libraries (esp. settings lib) are not found by default. Please use this workaround:

    $ DYLD_LIBRARY_PATH=$PWD/lib ./neptune3-ui -r

This will lookup the settings lib from the `./lib` folder.

To run the settings server, just run the executable RemoteSettings_server

# Run the UI without QtIVI

In case QtIVI is not installed, 'dummyimports' folder contains QML dummy implementation of QtIVI:

    $ QML2_IMPORT_PATH=/path/to/dummyimports neptune3-ui -r

# Building the settings app for Android

The NeptuneControlApp may also be built and run on android. For building just the app for android, there is a separate project file, settings_app_android.pro, in the root directory. The project includes only the app and its dependencies. This requires the android build of qt 5.12 with the qtivi built for android.

# QtSafeRenderer (QSR) support

To have QSR support inside Neptune3 it should be build and installed into the system: https://doc.qt.io/QtSafeRenderer/qtsr-installation-guide.html
Special tool (qtsafelayouttool) is required for compilation.

To enable QSR support add `use_qsr` to CONFIG line in .qmake.conf file.

Client to Neptunes's `Remote Settings Server` is used as values source (tell-tales states, speed,...) for Safe UI . Connection parameters are read from (`.config/Pelagicore/NeptuneControlApp.conf`). The first url in list is used for connection:

```
[lastUrls]
 1\url=tcp://127.0.0.1:9999
size=1
```

As a communication channel between Safe UI (neptune3-ui-qsr-cluster) and Non-SafeIU (neptune3-ui) TCP channel is suggested with client on Non-Safe UI part and server on Safe UI side.
Client is a part of QtSafeRenderer qml plugin. To set communication parameters manually, environment variables should be set for neptune3-ui:

* QT_SAFERENDER_IPADDRESS=127.0.0.1
* QT_SAFERENDER_PORT=1111

It can be done inside neptune3-ui by setting parameters in `am-config-.yaml` file:
```
 systemProperties:
  public:
   .
   qsrEnabled: yes
   qsrServerAddress: '127.0.0.1'
   qsrServerPort: '1111'
   .
```
In `am-config-.yaml` file `qsrEnabled` parameter switches loading Safe tell-tales inside cluster application. By default it is disabled.

`neptune3-ui-qsr-cluster` server listening port is set in settings file (`.config/Pelagicore/QSRCluster.conf`), default port is 1111.
```
 [connection]
 listen_port=1111
```
## Switching demo

On NUC target switching to Safe UI is possible via systemd service monitoring and adding start of neptune3-ui-qsr-cluster as an 'on failure' option.

In Neptune UI service file (`/lib/systemd/system/neptune3-qsr.service`):
```
[Unit]
...
OnFailure=neptune3-ui-qsr-cluster.service
```
In QSR service file (`/lib/systemd/system/neptune3-qsr.service`):
```
[Service]
...
Type=oneshot
ExecStart=/opt/neptune3/neptune3-ui-qsr-cluster -platform eglfs
workingDirectory=/opt/neptune3
Environment=QT_QPA_EGLFS_KMS_CONFIG=/opt/neptune3/neptune3-ui-qsr.json
```
EGLFS sttings json file (`/opt/neptune3/neptune3-ui-qsr.json`):
```
{
    "device": "/dev/dri/card0",
    "outputs": [
        { "name": "DP1", "virtualIndex": 2, "mode": "1920x1080"},
        { "name": "DP3", "virtualIndex": 0, "mode": "1920x1080"},
        { "name": "DP4", "virtualIndex": 1, "mode": "1920x1080"}
    ]
}
```
## Desktop demo case

To show layering, it is possible to set `gui/stick_to_cluster` key to true in settings file (`.config/Pelagicore/QSRCluster.conf`). Cluster window coordinates are sent to `safe-ui` and safe telltales window is moved to be on top of Cluster and match telltales positions. Enabled by default.
