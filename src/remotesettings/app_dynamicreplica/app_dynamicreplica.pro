QT += quick remoteobjects
CONFIG += c++11

include($$SOURCE_DIR/config.pri)

SOURCES += main.cpp \
    culturesettingsdynamic.cpp \
    audiosettingsdynamic.cpp \
    navigationsettingsdynamic.cpp \
    model3dsettingsdynamic.cpp \
    abstractdynamic.cpp \
    client.cpp

RESOURCES += qml.qrc

HEADERS += \
    culturesettingsdynamic.h \
    audiosettingsdynamic.h \
    navigationsettingsdynamic.h \
    model3dsettingsdynamic.h \
    abstractdynamic.h \
    client.h
