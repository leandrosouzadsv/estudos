import React, { ReactNode } from 'react';
import { View, ScrollView, StyleSheet } from 'react-native';
import { useThemeStore } from '../../store/themeStore';

interface Props {
  children: ReactNode;
}

export function ScreenWrapper({ children }: Props) {
  const theme = useThemeStore((state) => state.theme);

  return (
    <View style={[styles.container, { backgroundColor: theme.background }]}> 
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        {children}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    padding: 20,
    paddingBottom: 40,
  },
});
