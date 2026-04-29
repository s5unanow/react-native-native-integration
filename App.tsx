import {
  SafeAreaProvider,
  SafeAreaView,
} from 'react-native-safe-area-context';
import {StatusBar, StyleSheet, Text, View} from 'react-native';

import {VideoPlayer} from './src/components/VideoPlayer';

const SAMPLE_VIDEO_URL =
  'https://media.w3.org/2010/05/sintel/trailer.mp4';

function App() {
  return (
    <SafeAreaProvider>
      <StatusBar barStyle="light-content" backgroundColor="#14171f" />
      <SafeAreaView style={styles.container}>
        <View style={styles.header}>
          <Text style={styles.title}>Fabric Video Player Demo</Text>
          <Text style={styles.subtitle}>
            React Native app code rendering a Fabric native view.
          </Text>
        </View>

        <VideoPlayer sourceUrl={SAMPLE_VIDEO_URL} style={styles.player} />

        <View style={styles.footer}>
          <Text style={styles.caption}>
            The same JSX component is backed by AVPlayer on iOS and ExoPlayer
            on Android.
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
