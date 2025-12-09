import type { HostComponent, ViewProps } from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface NativeProps extends ViewProps {
  sourceUrl: string;
  paused?: boolean;
}

export default codegenNativeComponent<NativeProps>(
  'RTNVideoPlayer',
) as HostComponent<NativeProps>;
