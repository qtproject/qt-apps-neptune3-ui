CONFIG += force_qt
QT *= quick ivicore

INCLUDEPATH += $$OUT_PWD/../src/remotesettings/frontend \
               $$OUT_PWD/../src/drivedata/frontend \
               $$PWD

build_online_docs: {
    QMAKE_DOCS = $$PWD/online/neptune3ui.qdocconf
} else {
    QMAKE_DOCS = $$PWD/neptune3ui.qdocconf
}

DISTFILES += \
    *.qdocconf \
    $$PWD/Neptune3UIDoc \
    $$PWD/online/*.qdocconf \
    $$PWD/src/*.qdoc \
    $$PWD/src/images/*.jpg \
