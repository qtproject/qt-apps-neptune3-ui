TEMPLATE = aux

# Copy all QML files during the build time
do_copydata.commands = $(COPY_DIR) $$PWD/apps $$PWD/dev/apps $$PWD/imports $$PWD/sysui $$PWD/styles $$PWD/am-config.yaml $$PWD/Main.qml $$PWD/server.conf $$OUT_PWD

first.depends = do_copydata
!equals(PWD, $$OUT_PWD):QMAKE_EXTRA_TARGETS += first do_copydata
