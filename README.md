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
* Qt5 (branch 5.11) with qtwayland submodule and built with Open GL ES (-opengl es2 -opengles3)
* QtIvi (git://code.qt.io/qt/qtivi.git, branch 5.11)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch dev)

### Single-process UI (fallback option)

When in single process mode, all application code run in the same QML scene and
process as the System UI itself.

* Linux (e.g. Ubuntu 16.04) or macOS
* Qt5 (branch 5.11)
* QtIvi (git://code.qt.io/qt/qtivi.git, branch 5.11)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch dev)

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

This should report a Qt 5.11 version

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

The NeptuneControlApp may also be built and run on android. For building just the app for android, there is a separate project file, settings_app_android.pro, in the root directory. The project includes only the app and its dependencies. This requires the android build of qt 5.11 with the qtivi built for android.


