TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml

assets.files += assets/*
assets.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter2-extend/assets

app.files = $$FILES
app.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter2-extend

INSTALLS += app assets

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
