TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml

assets.files += assets/*
assets.path = /apps/chapter3-middleware/assets

app.files = $$FILES
app.path = /apps/chapter3-middleware

INSTALLS += app assets

OTHER_FILES += $$FILES

