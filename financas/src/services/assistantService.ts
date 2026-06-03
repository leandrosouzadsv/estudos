import { Receita } from '../domain/models/Receita';
import { Despesa } from '../domain/models/Despesa';

export const analyzeFinance = (receitas: Receita[], despesas: Despesa[]) => {
  const totalRevenue = receitas.reduce((sum, item) => sum + item.value, 0);
  const totalExpense = despesas.reduce((sum, item) => sum + item.value, 0);
  const savings = totalRevenue - totalExpense;
  const expenseRate = totalRevenue > 0 ? Math.round((totalExpense / totalRevenue) * 100) : 0;
  const categories = despesas.reduce<Record<string, number>>((acc, item) => {
    acc[item.category] = (acc[item.category] || 0) + item.value;
    return acc;
  }, {});

  const topCategory = Object.entries(categories).sort((a, b) => b[1] - a[1])[0];
  const messages: string[] = [];

  if (expenseRate > 70) {
    messages.push('Você está gastando mais de 70% da sua renda em despesas. Analise prioridades para melhorar sua reserva.');
  } else if (expenseRate > 50) {
    messages.push('Suas despesas estão equilibradas, mas há espaço para economizar mais este mês.');
  } else {
    messages.push('Seu custo de vida está muito saudável. Continue priorizando suas metas.');
  }

  if (topCategory) {
    messages.push(`A categoria com maior impacto foi ${topCategory[0]}: R$ ${topCategory[1].toFixed(2)}.`);
  }

  if (savings < 0) {
    messages.push('Você tem um saldo negativo. Priorize cortar gastos e aumentar receitas para sair do vermelho.');
  } else {
    const suggestion = Math.max(200, Math.round(savings * 0.12));
    messages.push(`Se economizar R$ ${suggestion} por mês, seu crescimento financeiro ficará mais estável.`);
  }

  return {
    totalRevenue,
    totalExpense,
    savings,
    expenseRate,
    messages,
  };
};
