import React, { useEffect } from 'react';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import AppRoutes from './routes';
import { initDatabase } from './database/sqlite';
import { seedInitialData } from './services/seedService';
import { useAuthStore } from './store/authStore';
import { useThemeStore } from './store/themeStore';

export default function App() {
  const initializeAuth = useAuthStore((state) => state.initialize);
  const themeMode = useThemeStore((state) => state.mode);

  useEffect(() => {
    initDatabase()
      .then(() => seedInitialData())
      .catch((error) => console.error('Erro inicializando DB:', error));
    initializeAuth();
  }, [initializeAuth]);

  return (
    <SafeAreaProvider>
      <StatusBar style={themeMode === 'dark' ? 'light' : 'dark'} />
      <AppRoutes />
    </SafeAreaProvider>
  );
}
