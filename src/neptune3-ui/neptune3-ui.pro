TEMPLATE = app
TARGET   = neptune3-ui

include(../../config.pri)

macos:CONFIG -= app_bundle
CONFIG *= no_private_qt_headers_warning link_pkgconfig

QT *= appman_main-private testlib gui-private

#TODO: Make it work also on macOS (or test whether the code below just works there)
unix:exists($$SOURCE_DIR/.git):GIT_REVISION=$$system(cd "$$SOURCE_DIR" && git describe --tags --always 2>/dev/null)

isEmpty(GIT_REVISION) {
    GIT_REVISION="unknown revision"
    GIT_COMMITTER_DATE="no date"
} else {
    GIT_COMMITTER_DATE=$$system(cd "$$SOURCE_DIR" && git show "$$GIT_REVISION" --pretty=format:"%ci" --no-patch 2>/dev/null)
}

DEFINES *= NEPTUNE_VERSION=\""\\\"$$GIT_REVISION, $$GIT_COMMITTER_DATE\\\""\"

SOURCES = main.cpp ApplicationInfo.cpp ApplicationModel.cpp
HEADERS = ApplicationInfo.h ApplicationModel.h

DESTDIR = $$OUT_PWD/../../

DEFINES += "NEPTUNE_ICONS_PATH=$$INSTALL_PREFIX/neptune3/imports/assets/icons"

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target
