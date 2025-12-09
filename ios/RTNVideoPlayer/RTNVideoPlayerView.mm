#import "RTNVideoPlayerView.h"
#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <react/renderer/components/RTNVideoPlayerSpec/ComponentDescriptors.h>
#import <react/renderer/components/RTNVideoPlayerSpec/Props.h>
#import <react/renderer/components/RTNVideoPlayerSpec/EventEmitters.h>
#import "ReactNativeNativeIntegration-Swift.h"

using namespace facebook::react;

@implementation RTNVideoPlayerView {
    RTNVideoPlayerViewSwift *_view;
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

        _view = [[RTNVideoPlayerViewSwift alloc] init];

        // Setup event callbacks
        __weak RTNVideoPlayerView *weakSelf = self;

        _view.onVideoProgress = ^(NSDictionary *event) {
            RTNVideoPlayerView *strongSelf = weakSelf;
            if (strongSelf && strongSelf->_eventEmitter) {
                double currentTime = [[event objectForKey:@"currentTime"] doubleValue];
                double duration = [[event objectForKey:@"duration"] doubleValue];
                double progress = [[event objectForKey:@"progress"] doubleValue];

                auto emitter = std::static_pointer_cast<RTNVideoPlayerEventEmitter const>(strongSelf->_eventEmitter);
                emitter->onVideoProgress({currentTime, duration, progress});
            }
        };

        _view.onVideoEnd = ^(NSDictionary *event) {
            RTNVideoPlayerView *strongSelf = weakSelf;
            if (strongSelf && strongSelf->_eventEmitter) {
                auto emitter = std::static_pointer_cast<RTNVideoPlayerEventEmitter const>(strongSelf->_eventEmitter);
                emitter->onVideoEnd({});
            }
        };

        self.contentView = _view;
    }
    return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<RTNVideoPlayerProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<RTNVideoPlayerProps const>(props);

    if (oldViewProps.sourceUrl != newViewProps.sourceUrl) {
        NSString *sourceUrl = [[NSString alloc] initWithUTF8String:newViewProps.sourceUrl.c_str()];
        _view.sourceUrl = sourceUrl;
    }

    if (oldViewProps.paused != newViewProps.paused) {
        _view.paused = newViewProps.paused;
    }

    [super updateProps:props oldProps:oldProps];
}

@end

Class<RCTComponentViewProtocol> RTNVideoPlayerCls(void)
{
    return RTNVideoPlayerView.class;
}
