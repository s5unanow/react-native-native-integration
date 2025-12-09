import React, { useState } from 'react';
import { SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { VideoPlayer } from './src/components/VideoPlayer';

// Sample video URL (Big Buck Bunny - free to use)
const SAMPLE_VIDEO = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = Math.floor(seconds % 60);
  return `${mins}:${secs.toString().padStart(2, '0')}`;
}

function App(): React.JSX.Element {
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [progress, setProgress] = useState(0);
  const [ended, setEnded] = useState(false);

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Fabric Video Player Demo</Text>
      </View>

      <VideoPlayer
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
