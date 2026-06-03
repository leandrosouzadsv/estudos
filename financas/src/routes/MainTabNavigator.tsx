import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { MaterialIcons } from '@expo/vector-icons';
import DashboardScreen from '../screens/Main/DashboardScreen';
import RevenueScreen from '../screens/Main/RevenueScreen';
import ExpenseScreen from '../screens/Main/ExpenseScreen';
import SavingsScreen from '../screens/Main/SavingsScreen';
import GoalsScreen from '../screens/Main/GoalsScreen';
import TipsScreen from '../screens/Main/TipsScreen';
import { useThemeStore } from '../store/themeStore';

const Tab = createBottomTabNavigator();

const iconMap: Record<string, string> = {
  Dashboard: 'dashboard',
  Receitas: 'attach-money',
  Despesas: 'shopping-cart',
  Reserva: 'account-balance',
  Objetivos: 'flag',
  Dicas: 'lightbulb',
};

export default function MainTabNavigator() {
  const theme = useThemeStore((state) => state.theme);

  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarActiveTintColor: theme.primary,
        tabBarInactiveTintColor: theme.muted,
        tabBarStyle: {
          backgroundColor: theme.surface,
          borderTopColor: theme.border,
          height: 68,
        },
        tabBarLabelStyle: {
          fontSize: 12,
          paddingBottom: 4,
        },
        tabBarIcon: ({ color, size }) => (
          <MaterialIcons name={iconMap[route.name] ?? 'circle'} size={size} color={color} />
        ),
      })}
    >
      <Tab.Screen name="Dashboard" component={DashboardScreen} />
      <Tab.Screen name="Receitas" component={RevenueScreen} />
      <Tab.Screen name="Despesas" component={ExpenseScreen} />
      <Tab.Screen name="Reserva" component={SavingsScreen} />
      <Tab.Screen name="Objetivos" component={GoalsScreen} />
      <Tab.Screen name="Dicas" component={TipsScreen} />
    </Tab.Navigator>
  );
}
