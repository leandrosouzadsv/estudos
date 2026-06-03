import React, { useEffect } from 'react';
import { View, Text, StyleSheet, FlatList } from 'react-native';
import { useAuthStore } from '../../store/authStore';
import { useFinancialStore } from '../../store/financialStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';
import { useThemeStore } from '../../store/themeStore';

export default function TipsScreen() {
  const theme = useThemeStore((state) => state.theme);
  const user = useAuthStore((state) => state.user);
  const assistantMessages = useFinancialStore((state) => state.assistantMessages);
  const refreshDashboard = useFinancialStore((state) => state.refreshDashboard);

  useEffect(() => {
    if (user) refreshDashboard(user.id);
  }, [user, refreshDashboard]);

  return (
    <ScreenWrapper>
      <Header title="Dicas" subtitle="Sugestões práticas para economizar" />
      <View style={[styles.card, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
        <Text style={[styles.description, { color: theme.muted }]}>O assistente coleta seus dados e transforma em sugestões claras. Use essas recomendações para ajustar hábitos de consumo.</Text>
      </View>
      <FlatList
        data={assistantMessages}
        keyExtractor={(item, index) => `${item}-${index}`}
        renderItem={({ item }) => (
          <View style={[styles.tipCard, { backgroundColor: theme.background, borderColor: theme.border }]}> 
            <Text style={[styles.tipText, { color: theme.text }]}>{item}</Text>
          </View>
        )}
        ListEmptyComponent={<Text style={[styles.empty, { color: theme.muted }]}>Ainda não há dicas. Adicione receitas e despesas para começar.</Text>}
      />
    </ScreenWrapper>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 24,
    padding: 18,
    borderWidth: 1,
    marginBottom: 18,
  },
  description: {
    fontSize: 14,
    lineHeight: 22,
  },
  tipCard: {
    borderWidth: 1,
    borderRadius: 20,
    padding: 16,
    marginBottom: 14,
  },
  tipText: {
    fontSize: 14,
    lineHeight: 22,
  },
  empty: {
    marginTop: 24,
    textAlign: 'center',
  },
});
