TEMPLATE = subdirs

SUBDIRS += neptune3-ui
SUBDIRS += remotesettings \
           drivedata

#build Qt Safe Renderer Cluster
qtHaveModule(qtsaferenderer){
    SUBDIRS += neptune3-ui-qsr-cluster
    neptune3-ui-qsr-cluster.depends = drivedata remotesettings
}
