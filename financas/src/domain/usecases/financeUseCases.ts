import { Receita } from '../models/Receita';
import { Despesa } from '../models/Despesa';
import { Reserva } from '../models/Reserva';
import { Objetivo } from '../models/Objetivo';
import {
  getAllReceitas,
  getAllDespesas,
  getAllReservas,
  getAllObjetivos,
  createReceita,
  createDespesa,
  createReserva,
  createObjetivo,
  updateObjetivoProgress,
  getSummaryByUser,
} from '../../repositories/financeRepository';

export const fetchDashboardData = async (userId: number) => {
  return getSummaryByUser(userId);
};

export const fetchReceitas = async (userId: number) => getAllReceitas(userId);
export const fetchDespesas = async (userId: number) => getAllDespesas(userId);
export const fetchReservas = async (userId: number) => getAllReservas(userId);
export const fetchObjetivos = async (userId: number) => getAllObjetivos(userId);

export const addReceita = async (payload: Omit<Receita, 'id' | 'createdAt'>) => createReceita(payload);
export const addDespesa = async (payload: Omit<Despesa, 'id' | 'createdAt'>) => createDespesa(payload);
export const addReserva = async (payload: Omit<Reserva, 'id' | 'createdAt'>) => createReserva(payload);
export const addObjetivo = async (payload: Omit<Objetivo, 'id' | 'createdAt'>) => createObjetivo(payload);
export const completeObjetivo = async (goalId: number, value: number) => updateObjetivoProgress(goalId, value);
