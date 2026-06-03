import React from 'react';
import { TouchableOpacity, Text, StyleSheet, ViewStyle } from 'react-native';
import { useThemeStore } from '../../store/themeStore';

interface Props {
  title: string;
  onPress: () => void;
  style?: ViewStyle;
  variant?: 'primary' | 'secondary' | 'ghost';
}

export function CustomButton({ title, onPress, style, variant = 'primary' }: Props) {
  const theme = useThemeStore((state) => state.theme);
  const backgroundColor = variant === 'secondary' ? theme.secondary : theme.primary;
  const textColor = variant === 'ghost' ? theme.primary : '#FFF';

  return (
    <TouchableOpacity style={[styles.button, { backgroundColor }, style]} onPress={onPress}>
      <Text style={[styles.text, { color: textColor }]}>{title}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    borderRadius: 16,
    paddingVertical: 14,
    paddingHorizontal: 20,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOpacity: 0.08,
    shadowOffset: { width: 0, height: 10 },
    shadowRadius: 20,
  },
  text: {
    fontSize: 16,
    fontWeight: '700',
  },
});
