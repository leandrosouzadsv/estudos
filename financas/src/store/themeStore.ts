import { create } from 'zustand';
import { themes } from '../theme';

type ThemeMode = 'light' | 'dark';

interface ThemeState {
  mode: ThemeMode;
  theme: typeof themes.light;
  toggleTheme: () => void;
  setMode: (mode: ThemeMode) => void;
}

export const useThemeStore = create<ThemeState>((set) => ({
  mode: 'light',
  theme: themes.light,
  toggleTheme: () => set((state) => ({
    mode: state.mode === 'light' ? 'dark' : 'light',
    theme: state.mode === 'light' ? themes.dark : themes.light,
  })),
  setMode: (mode) => set({ mode, theme: mode === 'light' ? themes.light : themes.dark }),
}));
