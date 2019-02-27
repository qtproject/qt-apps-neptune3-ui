VERSION  = 5.12.0
TEMPLATE = app
TARGET   = neptune3-ui

include(../../config.pri)

macos:CONFIG -= app_bundle
CONFIG *= no_private_qt_headers_warning link_pkgconfig

QT *= appman_main-private testlib gui-private

unix:exists($$SOURCE_DIR/.git):GIT_REVISION=$$system(cd "$$SOURCE_DIR" && git describe --tags --always 2>/dev/null)

isEmpty(GIT_REVISION) {
    GIT_REVISION="unknown revision"
    GIT_COMMITTER_DATE="no date"
} else {
    GIT_COMMITTER_DATE=$$system(cd "$$SOURCE_DIR" && git show "$$GIT_REVISION" --pretty=format:"%ci" --no-patch 2>/dev/null)
}

DEFINES *= "NEPTUNE_VERSION=$$VERSION"

DEFINES *= NEPTUNE_INFO=\""\\\"$$GIT_REVISION, $$GIT_COMMITTER_DATE\\\""\"

SOURCES = main.cpp

DESTDIR = $$OUT_PWD/../../

android: target.path = $$INSTALL_PREFIX
else: target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target

win32 {
    wrapper.files = neptune3-ui_wrapper.bat
    wrapper.path = $$INSTALL_PREFIX/neptune3
    INSTALLS += wrapper
}

android: {
    SOURCES += \
        urlinterceptor.cpp

    HEADERS += \
        urlinterceptor.h

    QML_ROOT_PATH = $$PWD/../../

    # Only add the C++ plugins here as these need to be deployed with androiddeployqt
    # Don't add QML only plugins here as they are imported using appmans import paths
    QML_IMPORT_PATH += $$OUT_PWD/../../imports_shared_cpp \

    ANDROID_EXTRA_PLUGINS += \
                        $$OUT_PWD/../../plugins \
                        $$[QT_INSTALL_PLUGINS]/ \

    ANDROID_EXTRA_LIBS += \
                        $$[QT_INSTALL_LIBS]/libQt5Sql.so \

}

use_qsr{
    #include Qt Safe Renderer part, generate file
    CONFIG += qtsaferenderer
    SAFE_QML = $$DESTDIR/apps/com.theqtcompany.cluster/panels/SafeTelltalesPanel.qml
    SAFE_LAYOUT_PATH = $$DESTDIR/qsr-safelayout
    DEFINES += USE_QT_SAFE_RENDERER
}
