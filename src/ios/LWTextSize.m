#import "LWTextSize.h"

/// Point size of UIFontTextStyleBody at the default content size category (UIContentSizeCategoryLarge).
static const CGFloat kLWBodyPointSizeDefault = 17.0;

@implementation LWTextSize {
	NSString *_watchCallbackId;
}

- (void)pluginInitialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(contentSizeCategoryDidChange:)
												 name:UIContentSizeCategoryDidChangeNotification
											   object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// Page (re)load: the JS callback ids of the previous page are gone.
- (void)onReset
{
	_watchCallbackId = nil;
}

/// The app's effective content size category (honours a per-app text size set in Settings > Accessibility > Per-App Settings).
- (NSInteger)textZoom
{
	CGFloat pointSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
	return (NSInteger)lround(pointSize / kLWBodyPointSizeDefault * 100.0);
}

- (void)getTextZoom:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)[self textZoom]];
	[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)watch:(CDVInvokedUrlCommand *)command
{
	_watchCallbackId = command.callbackId;
	[self notifyWatcher];
}

- (void)notifyWatcher
{
	if (_watchCallbackId == nil) {
		return;
	}
	CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)[self textZoom]];
	[result setKeepCallbackAsBool:YES];
	[self.commandDelegate sendPluginResult:result callbackId:_watchCallbackId];
}

- (void)contentSizeCategoryDidChange:(NSNotification *)notification
{
	[self notifyWatcher];
}

@end
