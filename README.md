# Prerequisite

* Qt5 (branch 5.10), built with Open GL ES (-opengl es2 -opengles3)
* QtIvi (branch dev)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch 5.10)
* Unix system (e.g. Ubuntu 16.04)

# Clone Repository

The repo uses git-lfs. You need to install [https://git-lfs.github.com/](git-lfs) first. Due to the SSL issues we need to use the HTTPS clone URL. To not enter every time the credentials you can use the git credential cache. The GitLab server uses a self-signed certification, so we need to override the ssl verification.

Here are the commands:

    $ git lfs install
    $ git clone git://code.qt.io/qt-apps/neptune3-ui.git
    $ cd neptune3-ui
    $ git config credential.helper cache
    $ git config http.sslverify false

# Build and install neptune3-ui

    $ qmake --version

This should report a Qt 5.10 version

    $ qmake INSTALL_PREFIX=/path/to/install/folder && make && make install

This will install all qml files and plugins into the neptune subfolder of '/path/to/install/folder'. If INSTALL_PREFIX is not defined, then this will build all neptune3-ui plugins and installs the complete neptune3-ui to /opt/neptune3 folder.

The installation part is optional.

* (Optional) Run scripts within the plugins/scripts folder to scan the media on the system

# Run entire UI

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


# Style Configuration

Neptune 3 UI supports different style configurations which can be used to adapt the style to the needs of the Hardware the UI should be running on.
The following resolutions are available:

* 1080x1920 - default
* 1280x800
* 1080x1920
* 768x1024

To set the UI for wanted (other than default one) resolution, set the 'QT_QUICK_CONTROLS_CONF' to the location of QtQuickControls 2 configuration file. Configuration files are within 'styles' folder (https://doc.qt.io/qt-5/qtquickcontrols2-environment.html).

NOTE: You need to have Open Sans font installed (see assets folder within the modules)
