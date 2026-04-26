import { StatusBar, StyleSheet, Text } from 'react-native';
import {
  SafeAreaProvider,
  SafeAreaView,
} from 'react-native-safe-area-context';

function App() {
  return (
    <SafeAreaProvider>
      <StatusBar barStyle="light-content" backgroundColor="#14171f" />
      <SafeAreaView style={styles.container}>
        <Text style={styles.title}>Native UI Integration Course</Text>
        <Text style={styles.subtitle}>
          This scaffold is ready for the next lesson: defining a typed Fabric
          component and connecting it to native iOS and Android code.
        </Text>
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#14171f',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  title: {
    color: '#f7f8fb',
    fontSize: 28,
    fontWeight: '700',
  },
  subtitle: {
    color: '#c5cad6',
    fontSize: 16,
    lineHeight: 24,
    marginTop: 12,
  },
});

export default App;
