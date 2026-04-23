import { useMemo, useRef, useState } from 'react';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { Pressable, StatusBar, StyleSheet, Text, View } from 'react-native';

import { VideoPlayer, type VideoPlayerRef } from './src/components/VideoPlayer';

const SAMPLE_VIDEO_URL =
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

function formatTime(seconds: number): string {
  if (!Number.isFinite(seconds) || seconds <= 0) {
    return '0:00';
  }

  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60);

  return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
}

function App() {
  const playerRef = useRef<VideoPlayerRef>(null);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [progress, setProgress] = useState(0);
  const [isPlaying, setIsPlaying] = useState(true);
  const [hasEnded, setHasEnded] = useState(false);

  const progressPercent = useMemo(
    () => `${Math.max(0, Math.min(progress, 1)) * 100}%` as `${number}%`,
    [progress],
  );

  const seekBy = (offset: number) => {
    const nextTime = Math.max(0, Math.min(duration, currentTime + offset));
    playerRef.current?.seekTo(nextTime);
  };

  const togglePlayback = () => {
    if (hasEnded) {
      playerRef.current?.seekTo(0);
      playerRef.current?.play();
      setCurrentTime(0);
      setProgress(0);
      setHasEnded(false);
      setIsPlaying(true);
      return;
    }

    if (isPlaying) {
      playerRef.current?.pause();
      setIsPlaying(false);
    } else {
      playerRef.current?.play();
      setIsPlaying(true);
    }
  };

  return (
    <SafeAreaProvider>
      <StatusBar barStyle="light-content" backgroundColor="#14171f" />
      <SafeAreaView style={styles.container}>
        <View style={styles.header}>
          <Text style={styles.title}>Fabric Video Player Demo</Text>
          <Text style={styles.subtitle}>
            React Native app code receiving Fabric native view events.
          </Text>
        </View>

        <VideoPlayer
          ref={playerRef}
          sourceUrl={SAMPLE_VIDEO_URL}
          style={styles.player}
          onProgress={event => {
            const isAtEnd =
              event.duration > 0 && event.currentTime >= event.duration;

            setCurrentTime(event.currentTime);
            setDuration(event.duration);
            setProgress(event.progress);
            setHasEnded(isAtEnd);

            if (isAtEnd) {
              setIsPlaying(false);
            }
          }}
          onEnd={() => {
            setHasEnded(true);
            setIsPlaying(false);
          }}
        />

        <View style={styles.eventPanel}>
          <View style={styles.progressTrack}>
            <View style={[styles.progressFill, { width: progressPercent }]} />
          </View>

          <View style={styles.timeRow}>
            <Text style={styles.timeText}>{formatTime(currentTime)}</Text>
            <Text style={styles.timeText}>{formatTime(duration)}</Text>
          </View>

          <View style={styles.stateRow}>
            <Text style={styles.stateLabel}>Native event state</Text>
            <Text style={styles.stateValue}>
              {hasEnded ? 'Ended' : 'Receiving progress'}
            </Text>
          </View>

          <View style={styles.controlsRow}>
            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Seek back 10 seconds"
              disabled={duration <= 0}
              onPress={() => seekBy(-10)}
              style={({ pressed }) => [
                styles.controlButton,
                duration <= 0 && styles.controlButtonDisabled,
                pressed && styles.controlButtonPressed,
              ]}
            >
              <Text style={styles.controlButtonText}>-10s</Text>
            </Pressable>

            <Pressable
              accessibilityRole="button"
              accessibilityLabel={
                hasEnded
                  ? 'Restart video'
                  : isPlaying
                  ? 'Pause video'
                  : 'Play video'
              }
              onPress={togglePlayback}
              style={({ pressed }) => [
                styles.playPauseButton,
                pressed && styles.controlButtonPressed,
              ]}
            >
              <Text style={styles.playPauseButtonText}>
                {hasEnded ? 'Restart' : isPlaying ? 'Pause' : 'Play'}
              </Text>
            </Pressable>

            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Seek forward 10 seconds"
              disabled={duration <= 0}
              onPress={() => seekBy(10)}
              style={({ pressed }) => [
                styles.controlButton,
                duration <= 0 && styles.controlButtonDisabled,
                pressed && styles.controlButtonPressed,
              ]}
            >
              <Text style={styles.controlButtonText}>+10s</Text>
            </Pressable>
          </View>
        </View>

        <View style={styles.footer}>
          <Text style={styles.caption}>
            AVPlayer and ExoPlayer emit the same progress payload: currentTime,
            duration, and progress.
          </Text>
        </View>
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#14171f',
    paddingHorizontal: 20,
  },
  header: {
    paddingTop: 24,
    paddingBottom: 18,
  },
  title: {
    color: '#f7f8fb',
    fontSize: 28,
    fontWeight: '700',
  },
  subtitle: {
    color: '#a9b0bf',
    fontSize: 16,
    lineHeight: 22,
    marginTop: 8,
  },
  player: {
    borderRadius: 8,
    overflow: 'hidden',
  },
  eventPanel: {
    paddingTop: 18,
  },
  progressTrack: {
    height: 8,
    backgroundColor: '#303541',
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#47d18c',
  },
  timeRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 8,
  },
  timeText: {
    color: '#d5dae5',
    fontSize: 13,
    fontVariant: ['tabular-nums'],
  },
  stateRow: {
    alignItems: 'center',
    borderColor: '#3a4050',
    borderRadius: 8,
    borderWidth: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 14,
    paddingHorizontal: 14,
    paddingVertical: 12,
  },
  stateLabel: {
    color: '#a9b0bf',
    fontSize: 14,
  },
  stateValue: {
    color: '#f7f8fb',
    fontSize: 14,
    fontWeight: '700',
  },
  controlsRow: {
    alignItems: 'center',
    flexDirection: 'row',
    gap: 12,
    justifyContent: 'center',
    marginTop: 18,
  },
  controlButton: {
    alignItems: 'center',
    backgroundColor: '#303541',
    borderRadius: 8,
    minWidth: 72,
    paddingHorizontal: 14,
    paddingVertical: 12,
  },
  controlButtonDisabled: {
    opacity: 0.45,
  },
  controlButtonPressed: {
    opacity: 0.78,
  },
  controlButtonText: {
    color: '#f7f8fb',
    fontSize: 14,
    fontWeight: '700',
  },
  playPauseButton: {
    alignItems: 'center',
    backgroundColor: '#47d18c',
    borderRadius: 8,
    minWidth: 110,
    paddingHorizontal: 20,
    paddingVertical: 12,
  },
  playPauseButtonText: {
    color: '#14171f',
    fontSize: 15,
    fontWeight: '800',
  },
  footer: {
    paddingTop: 18,
  },
  caption: {
    color: '#c5cad6',
    fontSize: 14,
    lineHeight: 20,
  },
});

export default App;
