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

!isEmpty(SQUISH_PREFIX) {
    SUBDIRS += squishhook
}
