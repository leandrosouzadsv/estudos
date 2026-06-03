import React, { useState } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { useAuthStore } from '../../store/authStore';
import { useFinancialStore } from '../../store/financialStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';
import { TextInputField } from '../../components/ui/TextInputField';
import { CustomButton } from '../../components/ui/CustomButton';
import { useThemeStore } from '../../store/themeStore';

const categories = ['Alimentação', 'Transporte', 'Saúde', 'Lazer', 'Casa', 'Outros'];

export default function ExpenseScreen() {
  const theme = useThemeStore((state) => state.theme);
  const user = useAuthStore((state) => state.user);
  const addDespesa = useFinancialStore((state) => state.addDespesa);
  const refreshDashboard = useFinancialStore((state) => state.refreshDashboard);

  const [description, setDescription] = useState('');
  const [value, setValue] = useState('');
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10));
  const [category, setCategory] = useState(categories[0]);

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
    await addDespesa({
      userId: user.id,
      description,
      value: amount,
      date,
      category,
    });
    await refreshDashboard(user.id);
    setDescription('');
    setValue('');
    Alert.alert('Sucesso', 'Despesa salva com sucesso.');
  };

  return (
    <ScreenWrapper>
      <Header title="Nova Despesa" subtitle="Registre seus gastos em segundos" />
      <View style={[styles.card, { backgroundColor: theme.surface }]}> 
        <TextInputField label="Descrição" value={description} onChangeText={setDescription} placeholder="Ex: Mercado" />
        <TextInputField label="Valor" value={value} onChangeText={setValue} placeholder="R$ 0,00" keyboardType="numeric" />
        <TextInputField label="Data" value={date} onChangeText={setDate} placeholder="YYYY-MM-DD" />
        <TextInputField label="Categoria" value={category} onChangeText={setCategory} placeholder="Ex: Alimentação" />
        <CustomButton title="Salvar despesa" onPress={handleSave} />
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
});
