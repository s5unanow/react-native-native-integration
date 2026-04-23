#import "RTNVideoPlayerView.h"

// Fabric related: Codegen creates these headers from
// src/specs/RTNVideoPlayerNativeComponent.ts. This Objective-C++ file uses them
// to connect the JS component name and typed props to the native Fabric
// component view.
#import <react/renderer/components/RTNVideoPlayerSpec/ComponentDescriptors.h>
#import <react/renderer/components/RTNVideoPlayerSpec/EventEmitters.h>
#import <react/renderer/components/RTNVideoPlayerSpec/Props.h>
#import <react/renderer/components/RTNVideoPlayerSpec/RCTComponentViewHelpers.h>

// Implementation detail: The Swift bridging header below re-exports every
// @objc class in this app module, so it also surfaces ReactNativeDelegate from
// AppDelegate.swift. We import its superclass header first to avoid an "unknown
// superclass" error when the Swift header is parsed from Objective-C++. In a
// module that did not also contain the AppDelegate, this import would not be
// needed.
#import <React_RCTAppDelegate/RCTDefaultReactNativeFactoryDelegate.h>

// Implementation detail: Xcode generates this header so Objective-C++ can
// instantiate and call the Swift UIView that owns the AVPlayer implementation.
#import "ReactNativeNativeIntegration-Swift.h"

using namespace facebook::react;

// Fabric related: Conforming to the codegen-generated protocol guarantees at
// compile time that this class declares the typed prop accessors Fabric expects
// for RTNVideoPlayer.
@interface RTNVideoPlayerView () <RCTRTNVideoPlayerViewProtocol>
@end

@implementation RTNVideoPlayerView {
  // Implementation detail: The Swift view is the actual platform UI that
  // renders and controls AVPlayer.
  RTNVideoPlayerViewSwift *_playerView;
}

// Fabric related: Fabric asks each component view for the descriptor that
// matches its generated ShadowNode. This binds the native class to the
// RTNVideoPlayer component.
+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RTNVideoPlayerComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    // Fabric related: RCTViewComponentView requires subclasses to seed _props
    // with the generated default props before any updates arrive from Fabric.
    static const auto defaultProps = std::make_shared<const RTNVideoPlayerProps>();
    _props = defaultProps;

    // Fabric related: Assigning contentView tells the base class to size and
    // clip the Swift view to match the Fabric component's bounds.
    // Implementation detail: RN handles layout; the Swift view handles
    // playback.
    _playerView = [[RTNVideoPlayerViewSwift alloc] initWithFrame:CGRectZero];
    __weak RTNVideoPlayerView *weakSelf = self;

    _playerView.onVideoProgress = ^(NSDictionary *event) {
      RTNVideoPlayerView *strongSelf = weakSelf;
      if (!strongSelf || !strongSelf->_eventEmitter) {
        return;
      }

      auto emitter = std::static_pointer_cast<RTNVideoPlayerEventEmitter const>(strongSelf->_eventEmitter);
      emitter->onVideoProgress({
        [[event objectForKey:@"currentTime"] doubleValue],
        [[event objectForKey:@"duration"] doubleValue],
        [[event objectForKey:@"progress"] doubleValue],
      });
    };

    _playerView.onVideoEnd = ^(__unused NSDictionary *event) {
      RTNVideoPlayerView *strongSelf = weakSelf;
      if (!strongSelf || !strongSelf->_eventEmitter) {
        return;
      }

      auto emitter = std::static_pointer_cast<RTNVideoPlayerEventEmitter const>(strongSelf->_eventEmitter);
      emitter->onVideoEnd({});
    };

    self.contentView = _playerView;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  // Fabric related: Fabric passes generic Props pointers. Cast them to the
  // generated RTNVideoPlayerProps type so we can read sourceUrl and paused
  // safely.
  const auto &oldViewProps = *std::static_pointer_cast<RTNVideoPlayerProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<RTNVideoPlayerProps const>(props);

  // Implementation detail: Apply paused before sourceUrl. While player is
  // still nil, the paused setter is a no-op; configurePlayer() then reads the
  // already-correct value when it builds the new AVPlayer. The reverse order
  // would briefly start playback and pause it on the next prop, causing an
  // audible flicker on a paused initial render.
  if (oldViewProps.paused != newViewProps.paused) {
    _playerView.paused = newViewProps.paused;
  }

  // Fabric related: Codegen exposes string props as std::string.
  // Implementation detail: Bridge to NSString so the Swift UIView can consume
  // it directly.
  if (oldViewProps.sourceUrl != newViewProps.sourceUrl) {
    _playerView.sourceUrl = [NSString stringWithUTF8String:newViewProps.sourceUrl.c_str()];
  }

  // Fabric related: Let the base Fabric view process standard ViewProps such as
  // layout, opacity, accessibility, pointer events, and other inherited
  // behavior.
  [super updateProps:props oldProps:oldProps];
}

- (void)prepareForRecycle
{
  // Fabric related: Fabric can reuse native views. Let the base reset the
  // standard ViewProps first, then clear video-specific state and props for the
  // next mount.
  [super prepareForRecycle];

  [_playerView reset];

  // Fabric related: Reset custom props to their generated defaults so the next
  // mount compares against a clean baseline.
  static const auto defaultProps = std::make_shared<const RTNVideoPlayerProps>();
  _props = defaultProps;
}

- (void)invalidate
{
  // Fabric related: invalidate covers the non-recycle path, where the view is
  // destroyed instead of being placed back into Fabric's reuse pool.
  [super invalidate];
  [_playerView reset];
}

@end
