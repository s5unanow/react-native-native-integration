#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"

@interface RTNVideoPlayerManager : RCTViewManager
@end

@implementation RTNVideoPlayerManager

RCT_EXPORT_MODULE(RTNVideoPlayer)

- (UIView *)view
{
  return [[UIView alloc] init]; // Will be replaced by Fabric
}

RCT_EXPORT_VIEW_PROPERTY(sourceUrl, NSString)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)

@end
