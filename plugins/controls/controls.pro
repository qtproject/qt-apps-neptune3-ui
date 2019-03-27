TEMPLATE = lib
CONFIG += qt plugin c++11 no_private_qt_headers_warning
QT += qml quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private quicktemplates2-private

uri = controls
EXTRA_FILES += $$files(*.qml, true)

load(qmlplugin)

SOURCES += \
    ControlsPlugin.cpp \
    neptuneiconlabel.cpp \
    qquickdefaultprogressbar.cpp

HEADERS += \
    neptuneiconlabel.h \
    neptuneiconlabel_p.h \
    qquickdefaultprogressbar_p.h

TARGET = controlsplugin
