import { queryDatabase } from '../database/sqlite';
import { Receita } from '../domain/models/Receita';
import { Despesa } from '../domain/models/Despesa';
import { Reserva } from '../domain/models/Reserva';
import { Objetivo } from '../domain/models/Objetivo';

const formatDate = () => new Date().toISOString();

export const createReceita = async (payload: Omit<Receita, 'id' | 'createdAt'>) => {
  await queryDatabase(
    `INSERT INTO receitas (user_id, description, value, date, category, recurring, created_at) VALUES (?, ?, ?, ?, ?, ?, ?);`,
    [payload.userId, payload.description, payload.value, payload.date, payload.category, payload.recurring ? 1 : 0, formatDate()]
  );
  const result = await queryDatabase('SELECT * FROM receitas WHERE user_id = ? ORDER BY id DESC LIMIT 1;', [payload.userId]);
  return result.rows._array[0] as Receita;
};

export const createDespesa = async (payload: Omit<Despesa, 'id' | 'createdAt'>) => {
  await queryDatabase(
    `INSERT INTO despesas (user_id, description, value, date, category, created_at) VALUES (?, ?, ?, ?, ?, ?);`,
    [payload.userId, payload.description, payload.value, payload.date, payload.category, formatDate()]
  );
  const result = await queryDatabase('SELECT * FROM despesas WHERE user_id = ? ORDER BY id DESC LIMIT 1;', [payload.userId]);
  return result.rows._array[0] as Despesa;
};

export const createReserva = async (payload: Omit<Reserva, 'id' | 'createdAt'>) => {
  await queryDatabase(
    `INSERT INTO reservas (user_id, title, amount, target, created_at) VALUES (?, ?, ?, ?, ?);`,
    [payload.userId, payload.title, payload.amount, payload.target ?? null, formatDate()]
  );
  const result = await queryDatabase('SELECT * FROM reservas WHERE user_id = ? ORDER BY id DESC LIMIT 1;', [payload.userId]);
  return result.rows._array[0] as Reserva;
};

export const createObjetivo = async (payload: Omit<Objetivo, 'id' | 'createdAt'>) => {
  await queryDatabase(
    `INSERT INTO objetivos (user_id, name, target_value, achieved_value, level, created_at) VALUES (?, ?, ?, ?, ?, ?);`,
    [payload.userId, payload.name, payload.targetValue, payload.achievedValue, payload.level ?? 1, formatDate()]
  );
  const result = await queryDatabase('SELECT * FROM objetivos WHERE user_id = ? ORDER BY id DESC LIMIT 1;', [payload.userId]);
  return result.rows._array[0] as Objetivo;
};

export const updateObjetivoProgress = async (goalId: number, amount: number) => {
  await queryDatabase(`UPDATE objetivos SET achieved_value = achieved_value + ? WHERE id = ?;`, [amount, goalId]);
  const result = await queryDatabase('SELECT * FROM objetivos WHERE id = ? LIMIT 1;', [goalId]);
  return result.rows._array[0] as Objetivo;
};

export const getAllReceitas = async (userId: number) => {
  const result = await queryDatabase('SELECT * FROM receitas WHERE user_id = ? ORDER BY date DESC;', [userId]);
  return result.rows._array as Receita[];
};

export const getAllDespesas = async (userId: number) => {
  const result = await queryDatabase('SELECT * FROM despesas WHERE user_id = ? ORDER BY date DESC;', [userId]);
  return result.rows._array as Despesa[];
};

export const getAllReservas = async (userId: number) => {
  const result = await queryDatabase('SELECT * FROM reservas WHERE user_id = ? ORDER BY created_at DESC;', [userId]);
  return result.rows._array as Reserva[];
};

export const getAllObjetivos = async (userId: number) => {
  const result = await queryDatabase('SELECT * FROM objetivos WHERE user_id = ? ORDER BY created_at DESC;', [userId]);
  return result.rows._array as Objetivo[];
};

export const getSummaryByUser = async (userId: number) => {
  const revenueResult = await queryDatabase('SELECT SUM(value) as total FROM receitas WHERE user_id = ?;', [userId]);
  const expenseResult = await queryDatabase('SELECT SUM(value) as total FROM despesas WHERE user_id = ?;', [userId]);
  const reserveResult = await queryDatabase('SELECT SUM(amount) as total FROM reservas WHERE user_id = ?;', [userId]);

  const totalRevenue = Number(revenueResult.rows._array[0]?.total ?? 0);
  const totalExpense = Number(expenseResult.rows._array[0]?.total ?? 0);
  const totalReserve = Number(reserveResult.rows._array[0]?.total ?? 0);

  return {
    totalRevenue,
    totalExpense,
    totalReserve,
    remaining: totalRevenue - totalExpense,
    expenseRate: totalRevenue > 0 ? Math.min(100, Math.round((totalExpense / totalRevenue) * 100)) : 0,
  };
};

export const getReceitaByCategory = async (userId: number) => {
  const result = await queryDatabase(
    'SELECT category, SUM(value) as total FROM receitas WHERE user_id = ? GROUP BY category ORDER BY total DESC;', [userId]
  );
  return result.rows._array as Array<{ category: string; total: number }>;
};

export const getDespesaByCategory = async (userId: number) => {
  const result = await queryDatabase(
    'SELECT category, SUM(value) as total FROM despesas WHERE user_id = ? GROUP BY category ORDER BY total DESC;', [userId]
  );
  return result.rows._array as Array<{ category: string; total: number }>;
};
