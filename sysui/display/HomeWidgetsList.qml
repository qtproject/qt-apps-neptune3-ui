import QtQuick 2.6

import models.application 1.0

ListModel {
    id: root
    Component.onCompleted: {
        root.append({"appInfo":ApplicationManagerModel.application("com.pelagicore.maps")});
        root.append({"appInfo":ApplicationManagerModel.application("com.pelagicore.calendar")});
    }
}
