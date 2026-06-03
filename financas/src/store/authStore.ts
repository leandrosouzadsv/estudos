import { create } from 'zustand';
import * as SecureStore from 'expo-secure-store';
import { User } from '../domain/models/User';
import { authenticateUser, createUser, findUserByUsername } from '../repositories/userRepository';

interface AuthState {
  user: User | null;
  loading: boolean;
  error: string | null;
  initialize: () => Promise<void>;
  login: (username: string, password: string) => Promise<boolean>;
  register: (payload: Omit<User, 'id' | 'createdAt'>) => Promise<boolean>;
  logout: () => Promise<void>;
}

const STORAGE_KEY = 'financas_user';

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  loading: true,
  error: null,
  initialize: async () => {
    const json = await SecureStore.getItemAsync(STORAGE_KEY);
    if (json) {
      const user = JSON.parse(json) as User;
      set({ user, loading: false });
      return;
    }
    set({ user: null, loading: false });
  },
  login: async (username, password) => {
    try {
      const user = await authenticateUser(username, password);
      if (!user) {
        set({ error: 'Usuário ou senha inválidos' });
        return false;
      }
      await SecureStore.setItemAsync(STORAGE_KEY, JSON.stringify(user));
      set({ user, error: null });
      return true;
    } catch (error) {
      set({ error: 'Falha ao logar no app' });
      return false;
    }
  },
  register: async (payload) => {
    try {
      const existing = await findUserByUsername(payload.username);
      if (existing) {
        set({ error: 'Nome de usuário já está em uso' });
        return false;
      }
      const user = await createUser(payload);
      await SecureStore.setItemAsync(STORAGE_KEY, JSON.stringify(user));
      set({ user, error: null });
      return true;
    } catch (error) {
      set({ error: 'Falha ao cadastrar o usuário' });
      return false;
    }
  },
  logout: async () => {
    await SecureStore.deleteItemAsync(STORAGE_KEY);
    set({ user: null });
  },
}));
