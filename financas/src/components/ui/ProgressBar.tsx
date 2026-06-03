import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useThemeStore } from '../../store/themeStore';

interface Props {
  value: number;
  label?: string;
}

export function ProgressBar({ value, label }: Props) {
  const theme = useThemeStore((state) => state.theme);
  const progress = Math.min(100, Math.max(0, value));

  return (
    <View style={styles.wrapper}>
      {label ? <Text style={[styles.label, { color: theme.muted }]}>{label}</Text> : null}
      <View style={[styles.track, { backgroundColor: theme.border }]}> 
        <View style={[styles.fill, { width: `${progress}%`, backgroundColor: theme.primary }]} />
      </View>
      <Text style={[styles.percent, { color: theme.text }]}>{progress}% concluído</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    marginVertical: 12,
  },
  label: {
    fontSize: 14,
    marginBottom: 8,
  },
  track: {
    width: '100%',
    height: 16,
    borderRadius: 12,
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
    borderRadius: 12,
  },
  percent: {
    marginTop: 8,
    fontSize: 13,
    fontWeight: '600',
  },
});
