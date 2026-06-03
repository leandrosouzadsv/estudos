import { queryDatabase } from '../database/sqlite';
import { User } from '../domain/models/User';

const formatDate = () => new Date().toISOString();

export const createUser = async (payload: Omit<User, 'id' | 'createdAt'>) => {
  const { name, email, username, password } = payload;
  const createdAt = formatDate();
  await queryDatabase(
    `INSERT INTO users (name, email, username, password, created_at) VALUES (?, ?, ?, ?, ?);`,
    [name, email, username, password, createdAt]
  );

  const result = await queryDatabase('SELECT * FROM users WHERE username = ? LIMIT 1;', [username]);
  return result.rows._array[0] as User;
};

export const findUserByUsername = async (username: string) => {
  const result = await queryDatabase('SELECT * FROM users WHERE username = ? LIMIT 1;', [username]);
  return result.rows._array[0] as User | undefined;
};

export const authenticateUser = async (username: string, password: string) => {
  const result = await queryDatabase(
    'SELECT * FROM users WHERE username = ? AND password = ? LIMIT 1;', 
    [username, password]
  );
  return result.rows._array[0] as User | undefined;
};
