import { User } from '../models/User';
import { createUser, findUserByUsername, authenticateUser } from '../../repositories/userRepository';

export const registerUser = async (payload: Omit<User, 'id' | 'createdAt'>) => {
  return createUser(payload);
};

export const loginUser = async (username: string, password: string) => {
  return authenticateUser(username, password);
};

export const getUserByUsername = async (username: string) => {
  return findUserByUsername(username);
};
