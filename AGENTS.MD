React Native Fabric Video Player - Repository Build Plan
Overview
Create a step-by-step example demonstrating how to build a Fabric Native Component (Video Player) for React Native 0.82. The repository uses branches to show progression during the lecture.

Branch Structure
main                    ← Final working version (merge all steps at the end)
├── step-0-scaffold     ← Clean RN 0.82 project (created by human)
├── step-1-js-spec      ← TypeScript component spec
├── step-2-ios          ← iOS native implementation
├── step-3-android      ← Android native implementation
├── step-4-usage        ← Basic usage example in app
├── step-5-events       ← Add progress event handling
└── step-6-commands     ← Add native commands (play/pause/seek)

Pre-requisites (Human does this)
bash# Create project
npx @react-native-community/cli init FabricVideoPlayerDemo --version 0.82.0

# Initialize git
cd FabricVideoPlayerDemo
git init
git add .
git commit -m "chore: initial RN 0.82 scaffold"
git branch step-0-scaffold

# Verify New Architecture is enabled (default in 0.82)
# iOS: check ios/Podfile for new_arch_enabled
# Android: check android/gradle.properties for newArchEnabled=true

Step 1: JavaScript Spec (step-1-js-spec)
Branch from: step-0-scaffold
Create files:
1.1 src/specs/RTNVideoPlayerNativeComponent.ts
typescriptimport type { HostComponent, ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface NativeProps extends ViewProps {
  sourceUrl: string;
  paused?: boolean;
}

export default codegenNativeComponent<NativeProps>(
  'RTNVideoPlayer',
) as HostComponent<NativeProps>;
1.2 src/components/VideoPlayer.tsx
typescriptimport React from 'react';
import { StyleSheet } from 'react-native';
import RTNVideoPlayer from '../specs/RTNVideoPlayerNativeComponent';

interface VideoPlayerProps {
  sourceUrl: string;
  paused?: boolean;
  style?: object;
}

export const VideoPlayer: React.FC<VideoPlayerProps> = ({
  sourceUrl,
  paused = false,
  style,
}) => {
  return (
    <RTNVideoPlayer
      sourceUrl={sourceUrl}
      paused={paused}
      style={[styles.player, style]}
    />
  );
};

const styles = StyleSheet.create({
  player: {
    width: '100%',
    aspectRatio: 16 / 9,
    backgroundColor: '#000',
  },
});
1.3 Update package.json - add codegenConfig
json{
  "codegenConfig": {
    "name": "RTNVideoPlayerSpec",
    "type": "components",
    "jsSrcsDir": "src/specs",
    "android": {
      "javaPackageName": "com.fabricvideoplayerdemo.videoplayer"
    }
  }
}
Commit: feat: add VideoPlayer component spec for Codegen

Step 2: iOS Implementation (step-2-ios)
Branch from: step-1-js-spec
Create files:
2.1 ios/RTNVideoPlayer/RTNVideoPlayerManager.mm
objc#import <React/RCTViewManager.h>
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
2.2 ios/RTNVideoPlayer/RTNVideoPlayerView.swift
swiftimport UIKit
import AVKit
import React

@objc(RTNVideoPlayerView)
class RTNVideoPlayerView: UIView {
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    @objc var sourceUrl: NSString = "" {
        didSet {
            setupPlayer()
        }
    }
    
    @objc var paused: Bool = false {
        didSet {
            paused ? player?.pause() : player?.play()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayer() {
        guard let url = URL(string: sourceUrl as String) else { return }
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = bounds
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        
        if !paused {
            player?.play()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
2.3 ios/RTNVideoPlayer/RTNVideoPlayerView.h
objc#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTNVideoPlayerView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END
2.4 ios/RTNVideoPlayer/RTNVideoPlayerView.mm (Fabric ComponentView)
objc#import "RTNVideoPlayerView.h"
#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <react/renderer/components/RTNVideoPlayerSpec/ComponentDescriptors.h>
#import <react/renderer/components/RTNVideoPlayerSpec/Props.h>
#import "FabricVideoPlayerDemo-Swift.h"

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
2.5 Update ios/Podfile - add Swift bridging if needed
ruby# Add to target 'FabricVideoPlayerDemo' block:
pod 'React-RCTFabric', :path => '../node_modules/react-native/ReactCommon'
2.6 Create bridging header ios/FabricVideoPlayerDemo-Bridging-Header.h
objc#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
Commands to run:
bashcd ios && pod install && cd ..
Commit: feat: add iOS native implementation for RTNVideoPlayer

Step 3: Android Implementation (step-3-android)
Branch from: step-2-ios
Create files:
3.1 android/app/src/main/java/com/fabricvideoplayerdemo/videoplayer/RTNVideoPlayerManager.kt
kotlinpackage com.fabricvideoplayerdemo.videoplayer

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.RTNVideoPlayerManagerInterface
import com.facebook.react.viewmanagers.RTNVideoPlayerManagerDelegate

@ReactModule(name = RTNVideoPlayerManager.NAME)
class RTNVideoPlayerManager : SimpleViewManager<RTNVideoPlayerView>(),
    RTNVideoPlayerManagerInterface<RTNVideoPlayerView> {

    private val delegate = RTNVideoPlayerManagerDelegate(this)

    override fun getDelegate(): ViewManagerDelegate<RTNVideoPlayerView> = delegate

    override fun getName(): String = NAME

    override fun createViewInstance(context: ThemedReactContext): RTNVideoPlayerView {
        return RTNVideoPlayerView(context)
    }

    @ReactProp(name = "sourceUrl")
    override fun setSourceUrl(view: RTNVideoPlayerView, sourceUrl: String?) {
        view.setSourceUrl(sourceUrl)
    }

    @ReactProp(name = "paused")
    override fun setPaused(view: RTNVideoPlayerView, paused: Boolean) {
        view.setPaused(paused)
    }

    companion object {
        const val NAME = "RTNVideoPlayer"
    }
}
3.2 android/app/src/main/java/com/fabricvideoplayerdemo/videoplayer/RTNVideoPlayerView.kt
kotlinpackage com.fabricvideoplayerdemo.videoplayer

import android.content.Context
import android.widget.FrameLayout
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView

@OptIn(UnstableApi::class)
class RTNVideoPlayerView(context: Context) : FrameLayout(context) {

    private var player: ExoPlayer? = null
    private var playerView: PlayerView
    private var currentUrl: String? = null
    private var isPaused: Boolean = false

    init {
        playerView = PlayerView(context).apply {
            layoutParams = LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT
            )
        }
        addView(playerView)
        setBackgroundColor(android.graphics.Color.BLACK)
    }

    fun setSourceUrl(url: String?) {
        if (url == currentUrl) return
        currentUrl = url
        
        url?.let { setupPlayer(it) }
    }

    fun setPaused(paused: Boolean) {
        isPaused = paused
        player?.playWhenReady = !paused
    }

    private fun setupPlayer(url: String) {
        releasePlayer()
        
        player = ExoPlayer.Builder(context).build().apply {
            playerView.player = this
            setMediaItem(MediaItem.fromUri(url))
            prepare()
            playWhenReady = !isPaused
        }
    }

    private fun releasePlayer() {
        player?.release()
        player = null
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        releasePlayer()
    }
}
3.3 android/app/src/main/java/com/fabricvideoplayerdemo/videoplayer/RTNVideoPlayerPackage.kt
kotlinpackage com.fabricvideoplayerdemo.videoplayer

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class RTNVideoPlayerPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return emptyList()
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return listOf(RTNVideoPlayerManager())
    }
}
3.4 Update android/app/src/main/java/com/fabricvideoplayerdemo/MainApplication.kt
kotlin// Add to getPackages():
packages.add(RTNVideoPlayerPackage())
3.5 Update android/app/build.gradle - add Media3/ExoPlayer dependency
gradledependencies {
    // ... existing deps
    implementation "androidx.media3:media3-exoplayer:1.2.1"
    implementation "androidx.media3:media3-ui:1.2.1"
}
Commit: feat: add Android native implementation for RTNVideoPlayer

Step 4: Basic Usage (step-4-usage)
Branch from: step-3-android
Update files:
4.1 App.tsx
typescriptimport React from 'react';
import { SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { VideoPlayer } from './src/components/VideoPlayer';

// Sample video URL (Big Buck Bunny - free to use)
const SAMPLE_VIDEO = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

function App(): React.JSX.Element {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Fabric Video Player Demo</Text>
      </View>
      
      <VideoPlayer 
        sourceUrl={SAMPLE_VIDEO}
        style={styles.player}
      />
      
      <View style={styles.info}>
        <Text style={styles.infoText}>
          This video player is a Fabric Native Component
        </Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a1a',
  },
  header: {
    padding: 20,
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
  },
  player: {
    width: '100%',
    aspectRatio: 16 / 9,
  },
  info: {
    padding: 20,
    alignItems: 'center',
  },
  infoText: {
    color: '#888',
    fontSize: 14,
  },
});

export default App;
4.2 Update iOS Info.plist - allow HTTP for sample video
xml<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
4.3 Update Android AndroidManifest.xml - add internet permission
xml<uses-permission android:name="android.permission.INTERNET" />
Commit: feat: add basic VideoPlayer usage example

Step 5: Events (step-5-events)
Branch from: step-4-usage
Update files:
5.1 Update src/specs/RTNVideoPlayerNativeComponent.ts
typescriptimport type { HostComponent, ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

type VideoProgressEvent = Readonly<{
  currentTime: Double;
  duration: Double;
  progress: Double;
}>;

type VideoEndEvent = Readonly<{}>;

export interface NativeProps extends ViewProps {
  sourceUrl: string;
  paused?: boolean;
  onVideoProgress?: DirectEventHandler<VideoProgressEvent>;
  onVideoEnd?: DirectEventHandler<VideoEndEvent>;
}

export default codegenNativeComponent<NativeProps>(
  'RTNVideoPlayer',
) as HostComponent<NativeProps>;
5.2 Update src/components/VideoPlayer.tsx
typescriptimport React from 'react';
import { StyleSheet } from 'react-native';
import RTNVideoPlayer from '../specs/RTNVideoPlayerNativeComponent';

interface VideoProgressData {
  currentTime: number;
  duration: number;
  progress: number;
}

interface VideoPlayerProps {
  sourceUrl: string;
  paused?: boolean;
  style?: object;
  onProgress?: (data: VideoProgressData) => void;
  onEnd?: () => void;
}

export const VideoPlayer: React.FC<VideoPlayerProps> = ({
  sourceUrl,
  paused = false,
  style,
  onProgress,
  onEnd,
}) => {
  return (
    <RTNVideoPlayer
      sourceUrl={sourceUrl}
      paused={paused}
      style={[styles.player, style]}
      onVideoProgress={onProgress ? (event) => onProgress(event.nativeEvent) : undefined}
      onVideoEnd={onEnd ? () => onEnd() : undefined}
    />
  );
};

const styles = StyleSheet.create({
  player: {
    width: '100%',
    aspectRatio: 16 / 9,
    backgroundColor: '#000',
  },
});
5.3 Update iOS Swift view to emit events
swift// Add to RTNVideoPlayerView.swift:
// - Timer for progress updates
// - NotificationCenter observer for video end
// - Event emission via RCTEventEmitter or direct event block
5.4 Update Android view to emit events
kotlin// Add to RTNVideoPlayerView.kt:
// - Player.Listener for progress and completion
// - Event emission via ReactContext
5.5 Update App.tsx with progress display
typescript// Add state for currentTime, duration
// Display progress bar and time
Commit: feat: add video progress and end events

Step 6: Commands (step-6-commands)
Branch from: step-5-events
Create/Update files:
6.1 Create src/specs/RTNVideoPlayerCommands.ts
typescriptimport type { HostComponent } from 'react-native';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import type { NativeProps } from './RTNVideoPlayerNativeComponent';

export const Commands = codegenNativeCommands<{
  play: (viewRef: React.ElementRef<HostComponent<NativeProps>>) => void;
  pause: (viewRef: React.ElementRef<HostComponent<NativeProps>>) => void;
  seekTo: (viewRef: React.ElementRef<HostComponent<NativeProps>>, time: Double) => void;
}>({
  supportedCommands: ['play', 'pause', 'seekTo'],
});
6.2 Update src/components/VideoPlayer.tsx
typescript// Add ref forwarding
// Expose imperative handle with play(), pause(), seekTo()
6.3 Update iOS implementation
objc// Add command handlers in RTNVideoPlayerView.mm
// Implement handleCommand method
6.4 Update Android implementation
kotlin// Add receiveCommand override in RTNVideoPlayerManager.kt
// Implement play, pause, seekTo in RTNVideoPlayerView.kt
6.5 Update App.tsx with controls
typescript// Add play/pause button
// Add seek slider
// Use ref to call commands
Commit: feat: add native commands for play, pause, seekTo

Final Steps
bash# Merge all into main
git checkout main
git merge step-6-commands

# Tag the final version
git tag v1.0.0

# Push all branches
git push origin --all
git push origin --tags

README.md Template
markdown# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native 0.82.

## Branches

Checkout each branch to follow along with the lecture:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82 project |
| `step-1-js-spec` | TypeScript component spec |
| `step-2-ios` | iOS native implementation |
| `step-3-android` | Android native implementation |
| `step-4-usage` | Basic usage example |
| `step-5-events` | Progress & completion events |
| `step-6-commands` | Native commands (play/pause/seek) |
| `main` | Complete working example |

## Running

\`\`\`bash
npm install
cd ios && pod install && cd ..
npm run ios
npm run android
\`\`\`

## Key Concepts

- Fabric Native Components
- Codegen & TypeScript specs  
- DirectEventHandler for events
- codegenNativeCommands for imperative API
- iOS: RCTViewComponentView
- Android: SimpleViewManager with Fabric delegate
