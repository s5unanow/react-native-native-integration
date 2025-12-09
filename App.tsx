import React, { useRef, useState } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
} from 'react-native';
import { VideoPlayer, VideoPlayerRef } from './src/components/VideoPlayer';

// Sample video URL (Big Buck Bunny - free to use)
const SAMPLE_VIDEO = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = Math.floor(seconds % 60);
  return `${mins}:${secs.toString().padStart(2, '0')}`;
}

function App(): React.JSX.Element {
  const playerRef = useRef<VideoPlayerRef>(null);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [progress, setProgress] = useState(0);
  const [isPlaying, setIsPlaying] = useState(true);
  const [ended, setEnded] = useState(false);

  const handlePlayPause = () => {
    if (isPlaying) {
      playerRef.current?.pause();
    } else {
      playerRef.current?.play();
    }
    setIsPlaying(!isPlaying);
  };

  const handleSeek = (direction: 'back' | 'forward') => {
    const seekAmount = direction === 'back' ? -10 : 10;
    const newTime = Math.max(0, Math.min(duration, currentTime + seekAmount));
    playerRef.current?.seekTo(newTime);
  };

  const handleRestart = () => {
    playerRef.current?.seekTo(0);
    playerRef.current?.play();
    setIsPlaying(true);
    setEnded(false);
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Fabric Video Player Demo</Text>
      </View>

      <VideoPlayer
        ref={playerRef}
        sourceUrl={SAMPLE_VIDEO}
        style={styles.player}
        onProgress={(data) => {
          setCurrentTime(data.currentTime);
          setDuration(data.duration);
          setProgress(data.progress);
          setEnded(false);
        }}
        onEnd={() => {
          setEnded(true);
          setIsPlaying(false);
        }}
      />

      <View style={styles.progressContainer}>
        <View style={styles.progressBar}>
          <View style={[styles.progressFill, { width: `${progress * 100}%` }]} />
        </View>
        <View style={styles.timeContainer}>
          <Text style={styles.timeText}>{formatTime(currentTime)}</Text>
          <Text style={styles.timeText}>{formatTime(duration)}</Text>
        </View>
      </View>

      <View style={styles.controls}>
        <TouchableOpacity
          style={styles.controlButton}
          onPress={() => handleSeek('back')}
        >
          <Text style={styles.controlButtonText}>-10s</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.controlButton, styles.playButton]}
          onPress={ended ? handleRestart : handlePlayPause}
        >
          <Text style={styles.playButtonText}>
            {ended ? 'Restart' : isPlaying ? 'Pause' : 'Play'}
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.controlButton}
          onPress={() => handleSeek('forward')}
        >
          <Text style={styles.controlButtonText}>+10s</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.info}>
        <Text style={styles.infoText}>
          {ended ? 'Video ended!' : 'This video player is a Fabric Native Component'}
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
  progressContainer: {
    paddingHorizontal: 20,
    paddingTop: 10,
  },
  progressBar: {
    height: 4,
    backgroundColor: '#333',
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#3b82f6',
  },
  timeContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 5,
  },
  timeText: {
    color: '#888',
    fontSize: 12,
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 20,
    gap: 20,
  },
  controlButton: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    backgroundColor: '#333',
    borderRadius: 8,
  },
  controlButtonText: {
    color: '#fff',
    fontSize: 14,
    fontWeight: '600',
  },
  playButton: {
    backgroundColor: '#3b82f6',
    paddingHorizontal: 30,
  },
  playButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
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
