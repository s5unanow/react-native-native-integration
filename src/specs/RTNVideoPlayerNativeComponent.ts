import type * as React from 'react';
import type { HostComponent, ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
} from 'react-native/Libraries/Types/CodegenTypes';
import { codegenNativeCommands, codegenNativeComponent } from 'react-native';

export type VideoProgressEvent = Readonly<{
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

export interface NativeCommands {
  play: (viewRef: React.ElementRef<HostComponent<NativeProps>>) => void;
  pause: (viewRef: React.ElementRef<HostComponent<NativeProps>>) => void;
  seekTo: (
    viewRef: React.ElementRef<HostComponent<NativeProps>>,
    time: Double,
  ) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['play', 'pause', 'seekTo'],
});

export default codegenNativeComponent<NativeProps>(
  'RTNVideoPlayer',
) as HostComponent<NativeProps>;
