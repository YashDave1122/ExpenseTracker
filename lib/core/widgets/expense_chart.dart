import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pre_dashboard/core/utils/formatters.dart';
import '../utils/constants.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  const ExpenseChart({super.key, required this.expensesByCategory});

  @override
  Widget build(BuildContext context) {
    if (expensesByCategory.isEmpty) {
      return _buildEmptyChart();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses by Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildChartSections(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // List<PieChartSectionData> _buildChartSections() {
  //   final total = expensesByCategory.values.fold(0, (sum, amount) => sum + amount);
  //
  //   return expensesByCategory.entries.map((entry) {
  //     final percentage = (entry.value / total) * 100;
  //     final color = _getColorForCategory(entry.key);
  //
  //     return PieChartSectionData(
  //       color: color,
  //       value: entry.value,
  //       title: '${percentage.toStringAsFixed(1)}%',
  //       radius: 60,
  //       titleStyle: const TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //       ),
  //     );
  //   }).toList();
  // }
  List<PieChartSectionData> _buildChartSections() {
    final total = expensesByCategory.values.fold(0.0, (sum, amount) => sum + amount);

    return expensesByCategory.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = _getColorForCategory(entry.key);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }


  Color _getColorForCategory(String category) {
    // final index = AppConstants.categories.indexOf(category) % AppConstants.colors.length;
    // final hexColor = AppConstants.colors[index].replaceAll('#', '');
    // return Color(int.parse('FF$hexColor', radix: 16));
    final index = AppConstants.expenseCategories.indexOf(category) % AppConstants.colors.length;
    final hexColor = AppConstants.colors[index].replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: expensesByCategory.entries.map((entry) {
        final color = _getColorForCategory(entry.key);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key} (${Formatters.formatCurrency(entry.value)})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No expenses yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}