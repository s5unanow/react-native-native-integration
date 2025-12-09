#import "RTNVideoPlayerView.h"
#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <react/renderer/components/RTNVideoPlayerSpec/ComponentDescriptors.h>
#import <react/renderer/components/RTNVideoPlayerSpec/Props.h>
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
