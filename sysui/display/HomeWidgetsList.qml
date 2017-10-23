import QtQuick 2.6

import models.application 1.0

// TODO: Make this just a filter of all AppInfo objects from ApplicationManagerModel,
//       filtering on asWidget === true
ListModel {
    id: root
    Component.onCompleted: {
        root.append({"appInfo":ApplicationManagerModel.application("com.pelagicore.maps")});
        root.append({"appInfo":ApplicationManagerModel.application("com.pelagicore.calendar")});
        root.append({"appInfo":ApplicationManagerModel.application("com.pelagicore.music")});
    }
}
