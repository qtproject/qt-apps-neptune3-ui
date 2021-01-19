TEMPLATE = subdirs

SUBDIRS = \
          controls \
          sizes \
          translation \
          widgetgrid \
          style \
          systeminfo \
          eventslisteners \
          com.pelagicore.map \
          fileutils \

!isEmpty(SQUISH_PREFIX) {
    SUBDIRS += squishhook
}
