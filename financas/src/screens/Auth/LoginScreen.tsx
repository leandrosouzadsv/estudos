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

export default function LoginScreen({ navigation }: Props) {
  const theme = useThemeStore((state) => state.theme);
  const login = useAuthStore((state) => state.login);
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    setLoading(true);
    const success = await login(username.trim(), password.trim());
    setLoading(false);
    if (!success) {
      Alert.alert('Aviso', 'Confira usuário e senha.');
    }
  };

  return (
    <ScreenWrapper>
      <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} style={styles.wrapper}>
        <Header title="Bem-vindo" subtitle="Gerencie suas finanças com inteligência" />
        <View style={styles.form}> 
          <TextInputField label="Usuário" value={username} onChangeText={setUsername} placeholder="Digite seu usuário" autoCapitalize="none" />
          <TextInputField label="Senha" value={password} onChangeText={setPassword} placeholder="Digite sua senha" secureTextEntry />
          <CustomButton title={loading ? 'Carregando...' : 'Entrar'} onPress={handleLogin} />
          <View style={styles.footer}>
            <Text style={[styles.footerText, { color: theme.muted }]}>Não tem conta?</Text>
            <TouchableOpacity onPress={() => navigation.navigate('Register')}>
              <Text style={[styles.footerLink, { color: theme.primary }]}> Cadastre-se</Text>
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
    marginTop: 32,
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
