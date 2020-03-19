VERSION  = 5.14.1
TEMPLATE = app
TARGET   = neptune3-ui

include(../../config.pri)

macos: {
    CONFIG -= app_bundle
    CONFIG *= separate_debug_info
}
CONFIG *= no_private_qt_headers_warning link_pkgconfig

QT *= appman_main-private testlib gui-private

load(gitUtils.prf)
DEFINES *= NEPTUNE_INFO=\""\\\"$$currentGitRevision()\\\""\"
DEFINES *= "NEPTUNE_VERSION=$$VERSION"

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

qtHaveModule(qtsaferenderer):load(qtsaferenderer-tools):qtsaferenderer-tools-available {
    #include Qt Safe Renderer part, generate file
    CONFIG += qtsaferenderer
    SAFE_QML = $$PWD/../../apps/com.theqtcompany.cluster/panels/SafeTelltalesPanel.qml
    SAFE_LAYOUT_FONTS = $$PWD/../../imports_shared/assets/fonts/
    SAFE_LAYOUT_PATH = $$DESTDIR/qsr-safelayout
    DEFINES += USE_QT_SAFE_RENDERER

    qsr-safelayout.files = $$DESTDIR/qsr-safelayout
    qsr-safelayout.path = $$INSTALL_PREFIX/neptune3
    INSTALLS += qsr-safelayout
}
