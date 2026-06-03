import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useThemeStore } from '../../store/themeStore';

interface Props {
  title: string;
  value: string;
  subtitle?: string;
  accent?: boolean;
}

export function CardResumo({ title, value, subtitle, accent }: Props) {
  const theme = useThemeStore((state) => state.theme);
  return (
    <LinearGradient
      colors={accent ? [theme.primary, theme.secondary] : [theme.surface, theme.surface]}
      style={[styles.container, { borderColor: theme.border }]}
    >
      <Text style={[styles.title, { color: accent ? '#fff' : theme.muted }]}>{title}</Text>
      <Text style={[styles.value, { color: accent ? '#fff' : theme.text }]}>{value}</Text>
      {subtitle ? <Text style={[styles.subtitle, { color: accent ? '#E0E7FF' : theme.muted }]}>{subtitle}</Text> : null}
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: {
    borderRadius: 22,
    padding: 18,
    minWidth: 160,
    marginRight: 16,
    borderWidth: 1,
    shadowColor: '#000',
    shadowOpacity: 0.08,
    shadowOffset: { width: 0, height: 8 },
    shadowRadius: 20,
  },
  title: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 8,
  },
  value: {
    fontSize: 22,
    fontWeight: '800',
  },
  subtitle: {
    marginTop: 6,
    fontSize: 13,
  },
});
