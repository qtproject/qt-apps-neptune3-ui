TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml

app.files = $$FILES
app.path = /apps/com.pelagicore.parking
INSTALLS += app

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
