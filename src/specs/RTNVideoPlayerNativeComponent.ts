import type { HostComponent, ViewProps } from 'react-native';
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
