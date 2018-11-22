TEMPLATE = lib
CONFIG += qt plugin c++11 no_private_qt_headers_warning
QT += qml quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private

uri = controls
EXTRA_FILES += $$files(*.qml, true)

load(qmlplugin)

SOURCES += \
    ControlsPlugin.cpp \
    qquickiconlabel.cpp \
    qquickicon.cpp \
    qquickdefaultprogressbar.cpp

HEADERS += \
    qquickiconlabel_p.h \
    qquickiconlabel_p_p.h \
    qquickicon_p.h \
    qquickdefaultprogressbar_p.h

TARGET = controlsplugin
