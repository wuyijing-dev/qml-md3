#include <QWindow>

#import <AppKit/AppKit.h>

/// Apply Cocoa layer clip so frameless QQuickWindow can drop Qt MultiEffect chrome masks.
void md3MacApplyCornerPreference(QWindow *window, bool rounded)
{
    if (!window)
        return;
    const WId wid = window->winId();
    if (!wid)
        return;
    NSView *view = (__bridge NSView *)reinterpret_cast<void *>(wid);
    if (!view)
        return;
    view.wantsLayer = YES;
    CALayer *layer = view.layer;
    if (!layer)
        return;
    const CGFloat radius = rounded ? 10.0 : 0.0;
    layer.masksToBounds = rounded;
    layer.cornerRadius = radius;
}
