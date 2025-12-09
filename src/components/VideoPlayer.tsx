import React from 'react';
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
