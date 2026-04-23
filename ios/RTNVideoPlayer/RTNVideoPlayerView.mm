#import "RTNVideoPlayerView.h"

#import <react/renderer/components/RTNVideoPlayerSpec/ComponentDescriptors.h>
#import <react/renderer/components/RTNVideoPlayerSpec/Props.h>
#import <react/renderer/components/RTNVideoPlayerSpec/RCTComponentViewHelpers.h>

#import "ReactNativeNativeIntegration-Swift.h"

using namespace facebook::react;

@interface RTNVideoPlayerView () <RCTRTNVideoPlayerViewProtocol>
@end

@implementation RTNVideoPlayerView {
  RTNVideoPlayerViewSwift *_playerView;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RTNVideoPlayerComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RTNVideoPlayerProps>();
    _props = defaultProps;

    _playerView = [[RTNVideoPlayerViewSwift alloc] initWithFrame:CGRectZero];
    self.contentView = _playerView;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<RTNVideoPlayerProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<RTNVideoPlayerProps const>(props);

  if (oldViewProps.sourceUrl != newViewProps.sourceUrl) {
    _playerView.sourceUrl = [NSString stringWithUTF8String:newViewProps.sourceUrl.c_str()];
  }

  if (oldViewProps.paused != newViewProps.paused) {
    _playerView.paused = newViewProps.paused;
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)prepareForRecycle
{
  [_playerView reset];

  static const auto defaultProps = std::make_shared<const RTNVideoPlayerProps>();
  _props = defaultProps;

  [super prepareForRecycle];
}

@end
