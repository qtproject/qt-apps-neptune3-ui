requires(linux|macos) # @todo add win

TEMPLATE = app
TARGET = neptune-cluster-app
QT *= quick gui core interfaceframework

isEmpty(INSTALL_PREFIX) {
    INSTALL_PREFIX=/opt
}

# check ogl-runtime
!disable-studio3d:qtHaveModule(studio3d) {
    QT *= studio3d
    DEFINES *= STUDIO3D_RUNTIME_INSTALLED
}

CONFIG += c++11
macos: CONFIG -= app_bundle

DESTDIR = $$OUT_PWD/../../

QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/$$relative_path($$INSTALL_PREFIX/neptune3/lib, $$INSTALL_PREFIX/neptune3/)
LIBS += -L$$LIB_DESTDIR -l$$qtLibraryTarget(remotesettings) -l$$qtLibraryTarget(drivedata)

SOURCES += \
        main.cpp

OTHER_FILES += $$files($$PWD/*.qml, true)

target.path = $$INSTALL_PREFIX/neptune3

installFiles.files = $$files($$PWD/*.qml, false) apps
installFiles.path = $$INSTALL_PREFIX/neptune3/neptune-cluster/
installFiles.CONFIG += no_check_exist

INSTALLS += target installFiles

# copy files in neptune-cluster-app build folder
FILES = main.qml ClusterRootStore.qml MockedWindows.qml Launcher.qml
do_copydata.commands += $(MKDIR) $$shell_path($$DESTDIR/neptune-cluster) $$escape_expand(\n\t)
for (f , FILES) {
    do_copydata.commands += $(COPY) $$shell_path($$PWD/$${f}) $$shell_path($$DESTDIR/neptune-cluster/) $$escape_expand(\n\t)
}

do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/apps) $$shell_path($$DESTDIR/neptune-cluster/) $$escape_expand(\n\t)

first.depends = do_copydata
QMAKE_EXTRA_TARGETS += first do_copydata
