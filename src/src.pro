TEMPLATE = subdirs

SUBDIRS += neptune3-ui
SUBDIRS += remotesettings \
           drivedata \
           connectivity

#build Qt Safe Renderer Cluster
qtHaveModule(qtsaferenderer):load(qtsaferenderer-tools):qtsaferenderer-tools-available {
    SUBDIRS += neptune3-ui-qsr-cluster
    neptune3-ui-qsr-cluster.depends = drivedata remotesettings
}
