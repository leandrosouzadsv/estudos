import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, Alert, FlatList } from 'react-native';
import { useAuthStore } from '../../store/authStore';
import { useFinancialStore } from '../../store/financialStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';
import { TextInputField } from '../../components/ui/TextInputField';
import { CustomButton } from '../../components/ui/CustomButton';
import { ProgressBar } from '../../components/ui/ProgressBar';
import { useThemeStore } from '../../store/themeStore';

export default function GoalsScreen() {
  const theme = useThemeStore((state) => state.theme);
  const user = useAuthStore((state) => state.user);
  const objetivos = useFinancialStore((state) => state.objetivos);
  const addObjetivo = useFinancialStore((state) => state.addObjetivo);
  const refreshDashboard = useFinancialStore((state) => state.refreshDashboard);

  const [name, setName] = useState('Viagem');
  const [targetValue, setTargetValue] = useState('5000');
  const [achievedValue, setAchievedValue] = useState('0');

  useEffect(() => {
    if (user) refreshDashboard(user.id);
  }, [user, refreshDashboard]);

  const handleSave = async () => {
    const target = Number(targetValue.replace(',', '.'));
    const achieved = Number(achievedValue.replace(',', '.'));
    if (!name || !target || target <= 0) {
      Alert.alert('Atenção', 'Informe nome e meta válida.');
      return;
    }
    if (!user) return;
    await addObjetivo({
      userId: user.id,
      name,
      targetValue: target,
      achievedValue: achieved,
      level: 1,
    });
    await refreshDashboard(user.id);
    setAchievedValue('0');
    Alert.alert('Objetivo criado', 'Meta financeira registrada com sucesso.');
  };

  return (
    <ScreenWrapper>
      <Header title="Objetivos" subtitle="Monitore suas metas com gamificação" />
      <View style={[styles.card, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
        <TextInputField label="Nome do objetivo" value={name} onChangeText={setName} placeholder="Ex: Viagem" />
        <TextInputField label="Valor alvo" value={targetValue} onChangeText={setTargetValue} placeholder="R$ 5.000" keyboardType="numeric" />
        <TextInputField label="Já alcançado" value={achievedValue} onChangeText={setAchievedValue} placeholder="R$ 1.000" keyboardType="numeric" />
        <CustomButton title="Adicionar objetivo" onPress={handleSave} />
      </View>
      <Text style={[styles.listTitle, { color: theme.text }]}>Progresso atual</Text>
      <FlatList
        data={objetivos}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => {
          const percent = item.targetValue > 0 ? Math.round((item.achievedValue / item.targetValue) * 100) : 0;
          const message = percent >= 100 ? 'Meta alcançada! Parabéns.' : `Faltam R$ ${(item.targetValue - item.achievedValue).toFixed(2)} para chegar lá.`;
          return (
            <View style={[styles.item, { backgroundColor: theme.background, borderColor: theme.border }]}> 
              <Text style={[styles.itemTitle, { color: theme.text }]}>{item.name}</Text>
              <Text style={[styles.itemSubtitle, { color: theme.muted }]}>{message}</Text>
              <ProgressBar value={percent} label={`${percent}% concluído`} />
            </View>
          );
        }}
        ListEmptyComponent={<Text style={[styles.empty, { color: theme.muted }]}>Nenhum objetivo cadastrado ainda.</Text>}
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
  listTitle: {
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 12,
  },
  item: {
    borderWidth: 1,
    borderRadius: 20,
    padding: 16,
    marginBottom: 14,
  },
  itemTitle: {
    fontSize: 16,
    fontWeight: '700',
  },
  itemSubtitle: {
    marginTop: 6,
    fontSize: 14,
  },
  empty: {
    marginTop: 24,
    textAlign: 'center',
  },
});
