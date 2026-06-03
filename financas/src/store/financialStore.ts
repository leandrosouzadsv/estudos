import { create } from 'zustand';
import { Receita } from '../domain/models/Receita';
import { Despesa } from '../domain/models/Despesa';
import { Reserva } from '../domain/models/Reserva';
import { Objetivo } from '../domain/models/Objetivo';
import {
  getAllReceitas,
  getAllDespesas,
  getAllReservas,
  getAllObjetivos,
  createReceita,
  createDespesa,
  createReserva,
  createObjetivo,
  getSummaryByUser,
  getReceitaByCategory,
  getDespesaByCategory,
} from '../repositories/financeRepository';
import { analyzeFinance } from '../services/assistantService';

interface DashboardSummary {
  totalRevenue: number;
  totalExpense: number;
  totalReserve: number;
  remaining: number;
  expenseRate: number;
}

interface FinancialState {
  receitas: Receita[];
  despesas: Despesa[];
  reservas: Reserva[];
  objetivos: Objetivo[];
  summary: DashboardSummary;
  assistantMessages: string[];
  categoriesRevenue: Array<{ category: string; total: number }>;
  categoriesExpense: Array<{ category: string; total: number }>;
  refreshDashboard: (userId: number) => Promise<void>;
  addReceita: (receita: Omit<Receita, 'id' | 'createdAt'>) => Promise<void>;
  addDespesa: (despesa: Omit<Despesa, 'id' | 'createdAt'>) => Promise<void>;
  addReserva: (reserva: Omit<Reserva, 'id' | 'createdAt'>) => Promise<void>;
  addObjetivo: (objetivo: Omit<Objetivo, 'id' | 'createdAt'>) => Promise<void>;
}

export const useFinancialStore = create<FinancialState>((set) => ({
  receitas: [],
  despesas: [],
  reservas: [],
  objetivos: [],
  summary: {
    totalRevenue: 0,
    totalExpense: 0,
    totalReserve: 0,
    remaining: 0,
    expenseRate: 0,
  },
  assistantMessages: [],
  categoriesRevenue: [],
  categoriesExpense: [],
  refreshDashboard: async (userId) => {
    const receitas = await getAllReceitas(userId);
    const despesas = await getAllDespesas(userId);
    const reservas = await getAllReservas(userId);
    const objetivos = await getAllObjetivos(userId);
    const summary = await getSummaryByUser(userId);
    const categoriesRevenue = await getReceitaByCategory(userId);
    const categoriesExpense = await getDespesaByCategory(userId);
    const assistant = analyzeFinance(receitas, despesas);

    set({
      receitas,
      despesas,
      reservas,
      objetivos,
      summary,
      categoriesRevenue,
      categoriesExpense,
      assistantMessages: assistant.messages,
    });
  },
  addReceita: async (receita) => {
    await createReceita(receita);
  },
  addDespesa: async (despesa) => {
    await createDespesa(despesa);
  },
  addReserva: async (reserva) => {
    await createReserva(reserva);
  },
  addObjetivo: async (objetivo) => {
    await createObjetivo(objetivo);
  },
}));
