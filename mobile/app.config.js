export default {
  expo: {
    name: 'DUS',
    slug: 'dus',
    scheme: 'dus',
    version: '1.0.0',
    orientation: 'portrait',
    icon: './assets/icon.png',
    userInterfaceStyle: 'light',
    newArchEnabled: false,
    splash: {
      image: './assets/splash-icon.png',
      resizeMode: 'contain',
      backgroundColor: '#FFFFFF',
    },
    ios: {
      supportsTablet: true,
      bundleIdentifier: 'com.vibers.dus',
    },
    android: {
      adaptiveIcon: {
        foregroundImage: './assets/adaptive-icon.png',
        backgroundColor: '#FFFFFF',
      },
      package: 'com.vibers.dus',
    },
    plugins: [
      'expo-router',
      'expo-font',
      'expo-secure-store',
      'expo-asset',
    ],
    extra: {
      apiUrl: 'https://dlab.vibers.co.kr',
      eas: {
        projectId: 'EAS_INIT으로_생성',
      },
    },
  },
};
