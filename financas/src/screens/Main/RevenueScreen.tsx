import React, { useState } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { useAuthStore } from '../../store/authStore';
import { useFinancialStore } from '../../store/financialStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';
import { TextInputField } from '../../components/ui/TextInputField';
import { CustomButton } from '../../components/ui/CustomButton';
import { useThemeStore } from '../../store/themeStore';

const categories = ['Salário', 'Investimentos', 'Freelance', 'Outros'];

export default function RevenueScreen() {
  const theme = useThemeStore((state) => state.theme);
  const user = useAuthStore((state) => state.user);
  const addReceita = useFinancialStore((state) => state.addReceita);
  const refreshDashboard = useFinancialStore((state) => state.refreshDashboard);

  const [description, setDescription] = useState('');
  const [value, setValue] = useState('');
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10));
  const [category, setCategory] = useState(categories[0]);
  const [recurring, setRecurring] = useState(false);

  const handleSave = async () => {
    if (!description || !value) {
      Alert.alert('Campos obrigatórios', 'Preencha descrição e valor.');
      return;
    }
    const amount = Number(value.replace(',', '.'));
    if (isNaN(amount) || amount <= 0) {
      Alert.alert('Valor inválido', 'Informe um valor numérico válido.');
      return;
    }
    if (!user) return;
    await addReceita({
      userId: user.id,
      description,
      value: amount,
      date,
      category,
      recurring,
    });
    await refreshDashboard(user.id);
    setDescription('');
    setValue('');
    Alert.alert('Sucesso', 'Receita salva com sucesso.');
  };

  return (
    <ScreenWrapper>
      <Header title="Nova Receita" subtitle="Registre suas entradas de forma simples" />
      <View style={[styles.card, { backgroundColor: theme.surface }]}> 
        <TextInputField label="Descrição" value={description} onChangeText={setDescription} placeholder="Ex: Salário de abril" />
        <TextInputField label="Valor" value={value} onChangeText={setValue} placeholder="R$ 0,00" keyboardType="numeric" />
        <TextInputField label="Data" value={date} onChangeText={setDate} placeholder="YYYY-MM-DD" />
        <TextInputField label="Categoria" value={category} onChangeText={setCategory} placeholder="Ex: Salário" />
        <View style={styles.row}> 
          <Text style={[styles.label, { color: theme.text }]}>Receita recorrente</Text>
          <CustomButton title={recurring ? 'Sim' : 'Não'} onPress={() => setRecurring(!recurring)} variant="ghost" style={styles.toggle} />
        </View>
        <CustomButton title="Salvar receita" onPress={handleSave} />
      </View>
    </ScreenWrapper>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 24,
    padding: 18,
    borderWidth: 1,
    borderColor: '#E5E7EB',
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 18,
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
  },
  toggle: {
    paddingHorizontal: 16,
  },
});
