import React from 'react';
import { View, Text, TextInput, StyleSheet, TextInputProps } from 'react-native';
import { useThemeStore } from '../../store/themeStore';

interface Props extends TextInputProps {
  label: string;
  error?: string;
}

export function TextInputField({ label, error, style, ...props }: Props) {
  const theme = useThemeStore((state) => state.theme);

  return (
    <View style={styles.container}>
      <Text style={[styles.label, { color: theme.muted }]}>{label}</Text>
      <TextInput
        style={[styles.input, { backgroundColor: theme.surface, color: theme.text, borderColor: theme.border }, style]}
        placeholderTextColor={theme.muted}
        {...props}
      />
      {error ? <Text style={[styles.error, { color: theme.danger }]}>{error}</Text> : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginBottom: 16,
  },
  label: {
    fontSize: 14,
    marginBottom: 8,
    fontWeight: '600',
  },
  input: {
    borderWidth: 1,
    borderRadius: 14,
    padding: 14,
    fontSize: 16,
  },
  error: {
    marginTop: 6,
    fontSize: 13,
  },
});
