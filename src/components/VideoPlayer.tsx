import React from 'react';
import { StyleSheet, type StyleProp, type ViewStyle } from 'react-native';
import RTNVideoPlayer from '../specs/RTNVideoPlayerNativeComponent';

interface VideoProgressData {
  currentTime: number;
  duration: number;
  progress: number;
}

interface VideoPlayerProps {
  sourceUrl: string;
  paused?: boolean;
  style?: StyleProp<ViewStyle>;
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
