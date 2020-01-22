#include "safewindow_mac.h"
#import <Appkit/AppKit.h>

void SafeWindowMac::setWindowTransparent(void *view)
{
    NSWindow *nsWindow = (static_cast<NSView *>(view)).window;
    nsWindow.backgroundColor = NSColor.clearColor;
}
