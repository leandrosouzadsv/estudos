import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Alert, FlatList } from 'react-native';
import { useAuthStore } from '../../store/authStore';
import { useFinancialStore } from '../../store/financialStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';
import { TextInputField } from '../../components/ui/TextInputField';
import { CustomButton } from '../../components/ui/CustomButton';
import { useThemeStore } from '../../store/themeStore';

export default function SavingsScreen() {
  const theme = useThemeStore((state) => state.theme);
  const user = useAuthStore((state) => state.user);
  const reservas = useFinancialStore((state) => state.reservas);
  const addReserva = useFinancialStore((state) => state.addReserva);
  const refreshDashboard = useFinancialStore((state) => state.refreshDashboard);

  const [title, setTitle] = useState('Reserva de emergência');
  const [amount, setAmount] = useState('');
  const [target, setTarget] = useState('A reserva ideal é 6x seu custo fixo');

  useEffect(() => {
    if (user) refreshDashboard(user.id);
  }, [user, refreshDashboard]);

  const handleSave = async () => {
    if (!title || !amount) {
      Alert.alert('Atenção', 'Informe título e valor da reserva.');
      return;
    }
    const value = Number(amount.replace(',', '.'));
    if (isNaN(value) || value <= 0) {
      Alert.alert('Valor inválido', 'Informe um valor numérico válido.');
      return;
    }
    if (!user) return;
    await addReserva({ userId: user.id, title, amount: value, target });
    await refreshDashboard(user.id);
    setTitle('Reserva de emergência');
    setAmount('');
    Alert.alert('Sucesso', 'Reserva registrada com sucesso.');
  };

  return (
    <ScreenWrapper>
      <Header title="Reserva" subtitle="Acompanhe o dinheiro guardado e o progresso" />
      <View style={[styles.card, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
        <Text style={[styles.label, { color: theme.muted }]}>Total acumulado</Text>
        <Text style={[styles.total, { color: theme.text }]}>R$ {reservas.reduce((sum, item) => sum + item.amount, 0).toFixed(2)}</Text>
      </View>
      <View style={[styles.card, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
        <TextInputField label="Título" value={title} onChangeText={setTitle} placeholder="Motivo da reserva" />
        <TextInputField label="Valor" value={amount} onChangeText={setAmount} placeholder="R$ 0,00" keyboardType="numeric" />
        <TextInputField label="Objetivo" value={target} onChangeText={setTarget} placeholder="Meta relacionada" />
        <CustomButton title="Adicionar reserva" onPress={handleSave} />
      </View>
      <Text style={[styles.listTitle, { color: theme.text }]}>Reservas registradas</Text>
      <FlatList
        data={reservas}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <View style={[styles.item, { backgroundColor: theme.background, borderColor: theme.border }]}> 
            <Text style={[styles.itemTitle, { color: theme.text }]}>{item.title}</Text>
            <Text style={[styles.itemValue, { color: theme.primary }]}>R$ {item.amount.toFixed(2)}</Text>
            <Text style={[styles.itemSubtitle, { color: theme.muted }]}>{item.target}</Text>
          </View>
        )}
        ListEmptyComponent={<Text style={[styles.empty, { color: theme.muted }]}>Nenhuma reserva cadastrada ainda.</Text>}
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
  label: {
    fontSize: 14,
    marginBottom: 8,
  },
  total: {
    fontSize: 32,
    fontWeight: '800',
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
    marginBottom: 12,
  },
  itemTitle: {
    fontSize: 16,
    fontWeight: '700',
  },
  itemValue: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '700',
  },
  itemSubtitle: {
    marginTop: 6,
    fontSize: 13,
  },
  empty: {
    marginTop: 24,
    textAlign: 'center',
  },
});
