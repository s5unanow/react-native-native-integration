import React from 'react';
import { SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { VideoPlayer } from './src/components/VideoPlayer';

// Sample video URL (Big Buck Bunny - free to use)
const SAMPLE_VIDEO = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

function App(): React.JSX.Element {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Fabric Video Player Demo</Text>
      </View>

      <VideoPlayer
        sourceUrl={SAMPLE_VIDEO}
        style={styles.player}
      />

      <View style={styles.info}>
        <Text style={styles.infoText}>
          This video player is a Fabric Native Component
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
