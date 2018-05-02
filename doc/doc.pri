build_online_docs: {
    QMAKE_DOCS = $$PWD/online/neptune3ui.qdocconf
} else {
    QMAKE_DOCS = $$PWD/neptune3ui.qdocconf
}

DISTFILES += \
    *.qdocconf \
    $$PWD/online/*.qdocconf \
    $$PWD/src/*.qdoc \
    $$PWD/src/images/*.png \
