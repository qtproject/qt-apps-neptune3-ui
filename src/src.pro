TEMPLATE = subdirs

SUBDIRS += neptune3-ui
SUBDIRS += remotesettings \
           drivedata

use_qsr{
    #build Qt Safe Renderer Cluster
    qtHaveModule(qtsaferenderer){
        SUBDIRS += neptune3-ui-qsr-cluster
        neptune3-ui-qsr-cluster.depends = drivedata remotesettings
    }
}
