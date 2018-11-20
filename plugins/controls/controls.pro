TEMPLATE = lib
CONFIG += qt plugin c++11 no_private_qt_headers_warning
QT += qml quick
QT += core-private gui-private qml-private quick-private quickcontrols2-private

uri = controls
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
qmlfiles.files = *.qml
qmlfiles.path = $$installPath
INSTALLS += qmlfiles

