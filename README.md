# Neptune 3 UI

Neptune 3 UI provides a UI implementation for Qt in In-Vehicle Infotainment (IVI) systems.
It demonstrates best practices for developing an Automotive UI with Qt Automotive Suite.

For a full overview, see https://doc.qt.io/Neptune3UI/neptune3ui-overview.html.

You can run Neptune 3 UI in one of two ways:

* from a Qt Automotive Suite Installation:
* from source

Both these options are described in: https://doc.qt.io/Neptune3UI/neptune3ui-install.html

#### Note
> Neptune 3 UI contains many graphic assets that are updated regularly. This requires the use of
> git-lfs. Make sure to install [https://git-lfs.github.com/](git-lfs) first. The Qt Company runs
> the git-lfs server and provides anonymous read access so that developers can clone the code without
> an account. Use the git credentials cache to avoid having to enter your credentials each time
> you push a commit. The GitLab server uses a self-signed certification, so you need to override
> the SSL verification with the following
> commands:
>   $ git lfs install
>   $ git clone git://code.qt.io/qt-apps/neptune3-ui.git
>   $ cd neptune3-ui
>   $ git config credential.helper cache
>   $ git config http.sslverify false

## Prerequisites and Dependencies

The prerequisites and dependencies vary based on whether you choose to run Neptune 3 UI in
single-process or multi-process mode.

### Multi-process UI (recommended)

In multi-process mode, applications run as independent processes, as Wayland clients, and the
System UI acts as a Wayland server, compositing the application windows in its own QML scene, as
regular QML items.

* a Linux installation
* Qt5 (branch 5.15) with qtwayland submodule and built with Open GL ES (-opengl es2 -opengles3)
* QtIvi (git://code.qt.io/qt/qtivi.git, branch 5.15)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch 5.15)

### Single-process UI (fallback option)

In single-process mode, all application code run in one process, which is the same QML scene and
process as the System UI itself.

* a Linux, Windows, or macOS installation
* Qt5 (branch 5.15)
* QtIvi (git://code.qt.io/qt/qtivi.git, branch 5.15)
* Qt Application Manager (git://code.qt.io/qt/qtapplicationmanager.git, branch 5.15)
