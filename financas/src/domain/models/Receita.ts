export interface Receita {
  id: number;
  userId: number;
  description: string;
  value: number;
  date: string;
  category: string;
  recurring: boolean;
  createdAt: string;
}
