import type { HostComponent } from 'react-native';
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';
import type { NativeProps } from './RTNVideoPlayerNativeComponent';

export const Commands = codegenNativeCommands<{
  play: (viewRef: React.ElementRef<HostComponent<NativeProps>>) => void;
  pause: (viewRef: React.ElementRef<HostComponent<NativeProps>>) => void;
  seekTo: (viewRef: React.ElementRef<HostComponent<NativeProps>>, time: Double) => void;
}>({
  supportedCommands: ['play', 'pause', 'seekTo'],
});
