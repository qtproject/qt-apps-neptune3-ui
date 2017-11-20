TEMPLATE = app
TARGET = triton-qmlscene

QT += qml quick quick-private gui-private core-private

SOURCES = triton-qmlscene.cpp

unix:!macos:system($$pkgConfigExecutable() --libs x11 xi xcb) {
    CONFIG += link_pkgconfig
    PKGCONFIG += xcb x11 xi
    SOURCES += ../../src/MouseTouchAdaptor.cpp
    HEADERS += ../../src/MouseTouchAdaptor.h
    DEFINES += TRITON_ENABLE_TOUCH_EMULATION
    INCLUDEPATH += $$SOURCE_DIR/src
    QT += testlib
}
