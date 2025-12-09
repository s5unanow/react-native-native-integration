import React, { forwardRef, useImperativeHandle, useRef } from 'react';
import { StyleSheet, type StyleProp, type ViewStyle } from 'react-native';
import RTNVideoPlayer from '../specs/RTNVideoPlayerNativeComponent';
import { Commands } from '../specs/RTNVideoPlayerCommands';

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

export interface VideoPlayerRef {
  play: () => void;
  pause: () => void;
  seekTo: (time: number) => void;
}

export const VideoPlayer = forwardRef<VideoPlayerRef, VideoPlayerProps>(({
  sourceUrl,
  paused = false,
  style,
  onProgress,
  onEnd,
}, ref) => {
  const nativeRef = useRef<React.ElementRef<typeof RTNVideoPlayer>>(null);

  useImperativeHandle(ref, () => ({
    play: () => {
      if (nativeRef.current) {
        Commands.play(nativeRef.current);
      }
    },
    pause: () => {
      if (nativeRef.current) {
        Commands.pause(nativeRef.current);
      }
    },
    seekTo: (time: number) => {
      if (nativeRef.current) {
        Commands.seekTo(nativeRef.current, time);
      }
    },
  }), []);

  return (
    <RTNVideoPlayer
      ref={nativeRef}
      sourceUrl={sourceUrl}
      paused={paused}
      style={[styles.player, style]}
      onVideoProgress={onProgress ? (event) => onProgress(event.nativeEvent) : undefined}
      onVideoEnd={onEnd ? () => onEnd() : undefined}
    />
  );
});

const styles = StyleSheet.create({
  player: {
    width: '100%',
    aspectRatio: 16 / 9,
    backgroundColor: '#000',
  },
});
