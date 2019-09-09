TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml

assets.files += assets/*
assets.path = /apps/chapter1-basics/assets

app.files = $$FILES
app.path = /apps/chapter1-basics

INSTALLS += app assets

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
