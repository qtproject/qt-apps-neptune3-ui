TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml

assets.files += assets/*
assets.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware/assets

app.files = $$FILES
app.path = $$[QT_INSTALL_EXAMPLES]/neptune3-ui/chapter3-middleware

INSTALLS += app assets

OTHER_FILES += $$FILES

