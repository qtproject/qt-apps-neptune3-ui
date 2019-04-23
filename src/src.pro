TEMPLATE = subdirs

SUBDIRS += neptune3-ui
SUBDIRS += dataprovider \
           drivedata

use_qsr{
    #build Qt Safe Renderer Cluster
    SUBDIRS += neptune3-ui-qsr-cluster
    neptune3-ui-qsr-cluster.depends = dataprovider-server
}
