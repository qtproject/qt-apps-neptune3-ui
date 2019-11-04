TEMPLATE = lib
CONFIG += plugin
QT += ivicore

LIBS += -L$$OUT_PWD/../ -l$$qtLibraryTarget(Parking)
INCLUDEPATH += $$OUT_PWD/../frontend
QMAKE_RPATHDIR += $$QMAKE_REL_RPATH_BASE/../../../

QFACE_FORMAT = qmlplugin
QFACE_SOURCES = ../parking.qface

load(ivigenerator)

DESTDIR = $$OUT_PWD/$$replace(URI, \\., /)

exists($$OUT_PWD/qmldir) {
    cpqmldir.files = $$OUT_PWD/qmldir \
                     $$OUT_PWD/plugins.qmltypes
    cpqmldir.path = $$DESTDIR
    cpqmldir.CONFIG = no_check_exist
    COPIES += cpqmldir

    installPath = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware/imports/$$replace(URI, \\., /)
    qmldir.files = $$OUT_PWD/qmldir \
                   $$OUT_PWD/plugins.qmltypes
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}
