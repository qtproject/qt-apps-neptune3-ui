TEMPLATE = subdirs
SUBDIRS += app \
           frontend \
           backend_simulator \
           imports \

app.depends = frontend
backend_simulator.depends = frontend
imports.depends = frontend

AM_MANIFEST = $$PWD/app/info.yaml
AM_PACKAGE_DIR = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware

load(am-app)
