import React from 'react';
import {StyleSheet} from 'react-native';
import type {StyleProp, ViewStyle} from 'react-native';

import RTNVideoPlayer from '../specs/RTNVideoPlayerNativeComponent';
import type {VideoProgressEvent} from '../specs/RTNVideoPlayerNativeComponent';

export type VideoProgressData = {
  currentTime: number;
  duration: number;
  progress: number;
};

export interface VideoPlayerProps {
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
  const handleProgress = onProgress
    ? (event: {nativeEvent: VideoProgressEvent}) => {
        onProgress({
          currentTime: event.nativeEvent.currentTime,
          duration: event.nativeEvent.duration,
          progress: event.nativeEvent.progress,
        });
      }
    : undefined;

  return (
    <RTNVideoPlayer
      sourceUrl={sourceUrl}
      paused={paused}
      style={[styles.player, style]}
      onVideoProgress={handleProgress}
      onVideoEnd={onEnd}
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
