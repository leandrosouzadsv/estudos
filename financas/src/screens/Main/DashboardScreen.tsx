import React, { useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { useAuthStore } from '../../store/authStore';
import { useFinancialStore } from '../../store/financialStore';
import { useThemeStore } from '../../store/themeStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';
import { CardResumo } from '../../components/ui/CardResumo';
import { PieChartCard } from '../../components/charts/PieChartCard';
import { CustomButton } from '../../components/ui/CustomButton';

export default function DashboardScreen() {
  const theme = useThemeStore((state) => state.theme);
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);
  const summary = useFinancialStore((state) => state.summary);
  const assistantMessages = useFinancialStore((state) => state.assistantMessages);
  const categoriesExpense = useFinancialStore((state) => state.categoriesExpense);
  const categoriesRevenue = useFinancialStore((state) => state.categoriesRevenue);
  const refreshDashboard = useFinancialStore((state) => state.refreshDashboard);

  useEffect(() => {
    if (user) {
      refreshDashboard(user.id);
    }
  }, [user, refreshDashboard]);

  const getRevenueExpenseData = () => {
    const revenueTotal = summary.totalRevenue;
    const expenseCategories = categoriesExpense.filter(cat => cat.total > 0);
    
    // Se não há categorias de despesa, mostra apenas receitas vs despesas totais
    if (expenseCategories.length === 0) {
      return [
        { category: 'Receitas', total: revenueTotal },
        { category: 'Despesas', total: summary.totalExpense },
      ].filter(item => item.total > 0);
    }
    
    // Mostra receitas + cada categoria de despesa
    const data = [{ category: 'Receitas', total: revenueTotal }];
    data.push(...expenseCategories);
    
    return data.filter(item => item.total > 0);
  };

  return (
    <ScreenWrapper>
      <View style={styles.headerRow}>
        <Header title="Dashboard" subtitle={`Olá, ${user?.name ?? 'usuário'}`} />
        <CustomButton title="Sair" onPress={logout} variant="ghost" style={{ alignSelf: 'flex-start' }} />
      </View>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.scrollCards} contentContainerStyle={styles.cardsContainer}>
        <CardResumo title="Receita total" value={`R$ ${summary.totalRevenue.toFixed(2)}`} subtitle="Sua entrada mensal" accent />
        <CardResumo title="Despesas totais" value={`R$ ${summary.totalExpense.toFixed(2)}`} subtitle={`${summary.expenseRate}% da receita`} />
        <CardResumo title="Reserva" value={`R$ ${summary.totalReserve.toFixed(2)}`} subtitle="Dinheiro guardado" />
        <CardResumo title="Saldo" value={`R$ ${summary.remaining.toFixed(2)}`} subtitle="Receitas restantes" />
      </ScrollView>
      <PieChartCard data={getRevenueExpenseData()} />
      <View style={[styles.section, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
        <Text style={[styles.sectionTitle, { color: theme.text }]}>Assistente Financeiro</Text>
        {assistantMessages.slice(0, 3).map((message, index) => (
          <View key={index} style={[styles.messageCard, { backgroundColor: theme.background }]}> 
            <Text style={[styles.messageText, { color: theme.text }]}>{message}</Text>
          </View>
        ))}
      </View>
      <View style={[styles.section, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
        <Text style={[styles.sectionTitle, { color: theme.text }]}>Resumo de economia</Text>
        <Text style={[styles.paragraph, { color: theme.muted }]}>Seu nível de organização financeira é construído com pequenas ações. Continue adicionando receitas, controlando despesas e completando objetivos.</Text>
      </View>
    </ScreenWrapper>
  );
}

const styles = StyleSheet.create({
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  scrollCards: {
    marginTop: 16,
    marginBottom: 24,
  },
  cardsContainer: {
    paddingVertical: 4,
  },
  section: {
    borderRadius: 24,
    borderWidth: 1,
    padding: 18,
    marginBottom: 18,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '700',
    marginBottom: 12,
  },
  messageCard: {
    borderRadius: 18,
    padding: 14,
    marginBottom: 10,
  },
  messageText: {
    fontSize: 14,
    lineHeight: 22,
  },
  paragraph: {
    fontSize: 14,
    lineHeight: 20,
  },
});
