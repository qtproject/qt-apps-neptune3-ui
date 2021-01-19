TEMPLATE = aux

# On a debug_and_release configuration, do the copying in the meta Makefile, not in the respective debug and release Makefiles
if(!debug_and_release | !build_pass) {
    # Copy all QML files during the build time
    DIRECTORIES = apps imports_shared imports_system sysui styles tests
    FILES = am-config-neptune.yaml am-config-lucee.yaml Main.qml

    # Special case for dev/apps folder as windows will put dev/apps into dev/apps in target folder
    win32: do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/dev/apps) $$shell_path($$OUT_PWD/apps) $$escape_expand(\n\t)
    else: do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/dev/apps) $$shell_path($$OUT_PWD) $$escape_expand(\n\t)

    for (d , DIRECTORIES) {
        win32: do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/$${d}) $$shell_path($$OUT_PWD/$${d}) $$escape_expand(\n\t)
        else: do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/$${d}) $$shell_path($$OUT_PWD) $$escape_expand(\n\t)
    }
    for (f , FILES) {
        do_copydata.commands += $(COPY) $$shell_path($$PWD/$${f}) $$shell_path($$OUT_PWD/$${f}) $$escape_expand(\n\t)
    }

    win32: do_copydata.commands += $(COPY) $$shell_path($$PWD/win32/server.conf) $$shell_path($$OUT_PWD/server.conf) $$escape_expand(\n\t)
    else: do_copydata.commands += $(COPY) $$shell_path($$PWD/server.conf) $$shell_path($$OUT_PWD/server.conf) $$escape_expand(\n\t)

    first.depends = do_copydata
    !equals(PWD, $$OUT_PWD):QMAKE_EXTRA_TARGETS += first do_copydata
}
