# Prerequisite

Qt 5.10
QtIvi
Unix system (e.g. Ubuntu 16.04)
Application Manager

# Clone Repository

The repo uses git-lfs. You need to install [https://git-lfs.github.com/](git-lfs) first. Due to the SSL issues we need to use the HTTPS clone URL. To not enter every time the credentials you can use the git credential cache. The GitLab server uses a self-signed certification, so we need to override the ssl verification.

Here are the commands:

    $ git lfs install
    $ GIT_SSL_NO_VERIFY=true git clone https://git-lfs.qt.io/Gerrit/triton-ui.git
    $ cd triton-ui
    $ git config credential.helper cache
    $ git config http.sslverify false

# Build and install triton-ui

    $ qmake --version

This should report a Qt 5.10 version

    $ qmake INSTALL_PREFIX=/path/to/install/folder && make && make install

This will install all qml files and plugins into the triton subfolder of '/path/to/install/folder'. If INSTALL_PREFIX is not defined, then this will build all triton-ui plugins and installs the complete triton-ui to /opt/triton folder.

The installation part is optional.

* (Optional) Run scripts within the plugins/scripts folder to scan the media on the system

# Run entire UI

Building Triton will make 'triton-ui' executable which will be then run:

    $ triton-ui -r

To get more detailed log output, run:

    $ triton-ui -r --verbose


# Run the UI without QtIVI

In case QtIVI is not installed, 'dummyimports' folder contains QML dummy implementation of QtIVI:

    $ QML2_IMPORT_PATH=/path/to/dummyimports triton-ui -r


# Style Configuration

Triton UI supports different style configurations which can be used to adapt the style to the needs of the Hardware the UI should be running on.
The following resolutions are available:

* 1080x1920 - default
* 1280x800
* 1080x1920
* 768x1024

To set the UI for wanted (other than default one) resolution, set the 'QT_QUICK_CONTROLS_CONF' to the location of QtQuickControls 2 configuration file. Configuration files are within 'styles' folder (https://doc.qt.io/qt-5/qtquickcontrols2-environment.html).

NOTE: You need to have Open Sans font installed (see assets folder within the modules)
