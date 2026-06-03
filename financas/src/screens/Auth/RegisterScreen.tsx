import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, KeyboardAvoidingView, Platform, Alert } from 'react-native';
import { TextInputField } from '../../components/ui/TextInputField';
import { CustomButton } from '../../components/ui/CustomButton';
import { useAuthStore } from '../../store/authStore';
import { useThemeStore } from '../../store/themeStore';
import { ScreenWrapper } from '../../components/layout/ScreenWrapper';
import { Header } from '../../components/layout/Header';

interface Props {
  navigation: any;
}

export default function RegisterScreen({ navigation }: Props) {
  const theme = useThemeStore((state) => state.theme);
  const register = useAuthStore((state) => state.register);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleRegister = async () => {
    if (!name || !email || !username || !password) {
      Alert.alert('Atenção', 'Preencha todos os campos antes de continuar.');
      return;
    }
    setLoading(true);
    const success = await register({ name, email, username, password });
    setLoading(false);
    if (!success) return;
    Alert.alert('Sucesso', 'Cadastro realizado. Bem-vindo!');
  };

  return (
    <ScreenWrapper>
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} style={styles.wrapper}>
        <Header title="Crie sua conta" subtitle="Comece a organizar suas finanças hoje" />
        <View style={styles.form}>
          <TextInputField label="Nome" value={name} onChangeText={setName} placeholder="Seu nome completo" />
          <TextInputField label="E-mail" value={email} onChangeText={setEmail} placeholder="seu@email.com" autoCapitalize="none" keyboardType="email-address" />
          <TextInputField label="Usuário" value={username} onChangeText={setUsername} placeholder="Nome de usuário" autoCapitalize="none" />
          <TextInputField label="Senha" value={password} onChangeText={setPassword} placeholder="Crie uma senha" secureTextEntry />
          <CustomButton title={loading ? 'Cadastrando...' : 'Cadastrar'} onPress={handleRegister} />
          <View style={styles.footer}>
            <Text style={[styles.footerText, { color: theme.muted }]}>Já tem conta?</Text>
            <TouchableOpacity onPress={() => navigation.navigate('Login')}>
              <Text style={[styles.footerLink, { color: theme.primary }]}> Fazer login</Text>
            </TouchableOpacity>
          </View>
        </View>
      </KeyboardAvoidingView>
    </ScreenWrapper>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
  },
  form: {
    marginTop: 20,
  },
  footer: {
    marginTop: 28,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  footerText: {
    fontSize: 14,
  },
  footerLink: {
    fontSize: 14,
    fontWeight: '700',
  },
});
