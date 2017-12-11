TEMPLATE = lib
TARGET  = translationplugin
QT += qml quick
CONFIG += qt plugin c++11
PRE_TARGETDEPS += ts

uri = com.pelagicore.translation
load(qmlplugin)

SOURCES += \
    plugin.cpp \
    translation.cpp \

HEADERS += \
    translation.h \

# var, prepend, append
defineReplace(prependAll) {
    for(a,$$1):result += $$2$${a}$$3
    return($$result)
}

assetsPath = $$PWD/../../imports/assets
qmlSysUiPath = $$PWD/../../sysui
importsPath = $$PWD/../../imports
appsPath = $$PWD/../../apps
# See qml files to scan while running lupdate/lrelease
lupdate_only {
    SOURCES += $$files($$shell_quote($$shell_path($${qmlSysUiPath}/))*.qml, true)
    SOURCES += $$files($$shell_quote($$shell_path($${importsPath}/))*.qml, true)
    SOURCES += $$files($$shell_quote($$shell_path($${appsPath}/))*.qml, true)
}

target.path = $$installPath

supportedLocales = \
    cs_CZ \
    de_DE \
    en_GB \
    en_US \
    zh_CN \
    # in_ID

TRANSLATIONS = $$prependAll(supportedLocales, $$assetsPath/translations/, .ts)

qtPrepareTool(LUPDATE, lupdate)
qtPrepareTool(LRELEASE, lrelease)

ts.commands = $$LUPDATE $$shell_quote($$_PRO_FILE_)
QMAKE_EXTRA_TARGETS += ts

qm.input = TRANSLATIONS
qm.output = $$shadowed($$assetsPath/translations)/${QMAKE_FILE_BASE}.qm
qm.depends = ts
qm.variable_out = PRE_TARGETDEPS
qm.commands = $${LRELEASE} ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
qm.name = LRELEASE ${QMAKE_FILE_IN}
qm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += qm

qmfiles.files = $$prependAll(supportedLocales, $$shadowed($$assetsPath/translations)/, .qm)
qmfiles.path = $$INSTALL_PREFIX/triton/imports/assets/translations
qmfiles.CONFIG += no_check_exist

INSTALLS += qmfiles
