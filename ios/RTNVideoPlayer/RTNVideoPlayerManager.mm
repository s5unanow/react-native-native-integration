#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "ReactNativeNativeIntegration-Swift.h"

@interface RTNVideoPlayerManager : RCTViewManager
@end

@implementation RTNVideoPlayerManager

RCT_EXPORT_MODULE(RTNVideoPlayer)

- (UIView *)view
{
  // Legacy (Paper) view manager. In the New Architecture, Fabric uses `RTNVideoPlayerView`
  // registered via `thirdPartyFabricComponents` in `AppDelegate.swift`.
  return [[RTNVideoPlayerViewSwift alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(sourceUrl, NSString)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)

@end
