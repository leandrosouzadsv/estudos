import React from 'react';
import { View, Text, StyleSheet, Dimensions } from 'react-native';
import Svg, { G, Path, Circle } from 'react-native-svg';
import { useThemeStore } from '../../store/themeStore';

interface Props {
  data: Array<{ category: string; total: number }>;
}

const palette = ['#4F46E5', '#2563EB', '#0EA5E9', '#14B8A6', '#22C55E', '#F59E0B', '#EF4444'];

const calculateArc = (value: number, radius: number, startAngle: number) => {
  const endAngle = startAngle + (value / 100) * 360;
  const largeArcFlag = value > 50 ? 1 : 0;
  const startX = radius + radius * Math.cos((Math.PI * startAngle) / 180);
  const startY = radius + radius * Math.sin((Math.PI * startAngle) / 180);
  const endX = radius + radius * Math.cos((Math.PI * endAngle) / 180);
  const endY = radius + radius * Math.sin((Math.PI * endAngle) / 180);
  return `M ${radius} ${radius} L ${startX} ${startY} A ${radius} ${radius} 0 ${largeArcFlag} 1 ${endX} ${endY} Z`;
};

export function PieChartCard({ data }: Props) {
  const theme = useThemeStore((state) => state.theme);
  const total = data.reduce((sum, item) => sum + item.total, 0) || 1;
  const chartData = data.slice(0, 5).map((item, index) => ({
    category: item.category,
    value: item.total,
    percent: (item.total / total) * 100,
    color: palette[index % palette.length],
  }));

  let startAngle = -90;
  const radius = 90;
  const size = radius * 2;

  return (
    <View style={[styles.card, { backgroundColor: theme.surface, borderColor: theme.border }]}> 
      <Text style={[styles.title, { color: theme.text }]}>Distribuição</Text>
      <View style={styles.chartRow}>
        <Svg width={size} height={size}>
          <G>
            <Circle cx={radius} cy={radius} r={radius} fill={theme.background} />
            {chartData.map((item, index) => {
              const path = calculateArc(item.percent, radius, startAngle);
              startAngle += (item.percent / 100) * 360;
              return <Path key={index} d={path} fill={item.color} />;
            })}
          </G>
        </Svg>
        <View style={styles.legendContainer}>
          {chartData.map((item, index) => (
            <View key={index} style={styles.legendItem}>
              <View style={[styles.dot, { backgroundColor: item.color }]} />
              <Text style={[styles.legendText, { color: theme.muted }]}>{item.category}</Text>
            </View>
          ))}
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 24,
    padding: 18,
    borderWidth: 1,
    marginBottom: 20,
    shadowColor: '#000',
    shadowOpacity: 0.06,
    shadowOffset: { width: 0, height: 10 },
    shadowRadius: 20,
  },
  title: {
    fontSize: 16,
    fontWeight: '700',
    marginBottom: 12,
  },
  chartRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  legendContainer: {
    flex: 1,
    marginLeft: 16,
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  dot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    marginRight: 8,
  },
  legendText: {
    fontSize: 12,
  },
});
