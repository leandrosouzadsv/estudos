import { findUserByUsername, createUser } from '../repositories/userRepository';
import { createReceita } from '../repositories/financeRepository';
import { createDespesa } from '../repositories/financeRepository';

export const seedInitialData = async () => {
  const existing = await findUserByUsername('administrador');
  if (existing) return;

  const user = await createUser({
    name: 'Administrador',
    email: 'admin@financas.com',
    username: 'administrador',
    password: '123456',
  });

  // Adicionar dados de exemplo para demonstrar o gráfico
  await createReceita({
    userId: user.id,
    category: 'Salário',
    description: 'Salário mensal',
    amount: 5000,
    date: new Date().toISOString(),
  });

  await createReceita({
    userId: user.id,
    category: 'Freelance',
    description: 'Projeto freelance',
    amount: 1500,
    date: new Date().toISOString(),
  });

  await createDespesa({
    userId: user.id,
    category: 'Alimentação',
    description: 'Compras do mês',
    amount: 800,
    date: new Date().toISOString(),
  });

  await createDespesa({
    userId: user.id,
    category: 'Transporte',
    description: 'Combustível e transporte',
    amount: 400,
    date: new Date().toISOString(),
  });

  await createDespesa({
    userId: user.id,
    category: 'Moradia',
    description: 'Aluguel',
    amount: 1200,
    date: new Date().toISOString(),
  });

  await createDespesa({
    userId: user.id,
    category: 'Lazer',
    description: 'Entretenimento',
    amount: 300,
    date: new Date().toISOString(),
  });
};
