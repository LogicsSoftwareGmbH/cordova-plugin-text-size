#import <Cordova/CDVPlugin.h>

/// Reports the system text size (Dynamic Type) as a percentage of the default size. See README.md.
@interface LWTextSize : CDVPlugin

- (void)getTextZoom:(CDVInvokedUrlCommand *)command;
- (void)watch:(CDVInvokedUrlCommand *)command;

@end
