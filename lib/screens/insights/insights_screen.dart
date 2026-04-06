import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/finance_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_card.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final categoryData = provider.categoryData;
    final total = categoryData.values.fold(0.0, (sum, value) => sum + value);
    final sortedCategories = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = sortedCategories.isEmpty
        ? null
        : sortedCategories.first;
    final theme = Theme.of(context);
    final mutedTextColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.mutedText;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Insights'),
        elevation: 0,
        backgroundColor: theme.cardColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insights',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.m),
            CustomCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.pie_chart,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Highest Spending Category',
                          style: TextStyle(color: mutedTextColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topCategory?.key ?? 'No category',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          topCategory != null
                              ? '₹ ${topCategory.value.toStringAsFixed(0)} spent'
                              : 'Add expenses to see insights',
                          style: TextStyle(color: mutedTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Breakdown',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  if (total == 0)
                    Center(
                      child: Text(
                        'No data available',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  else ...[
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: sortedCategories.map((entry) {
                            final color =
                                Colors.primaries[entry.key.hashCode %
                                    Colors.primaries.length];
                            return PieChartSectionData(
                              value: entry.value,
                              title:
                                  '${((entry.value / total) * 100).round()}%',
                              color: color,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Wrap(
                      spacing: AppSpacing.m,
                      runSpacing: AppSpacing.s,
                      children: sortedCategories.map((entry) {
                        final color =
                            Colors.primaries[entry.key.hashCode %
                                Colors.primaries.length];
                        return _legendItem(
                          context,
                          entry.key,
                          entry.value,
                          color,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(
    BuildContext context,
    String title,
    double value,
    Color color,
  ) {
    final mutedTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.mutedText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title • ₹ ${value.toStringAsFixed(0)}',
          style: TextStyle(color: mutedTextColor),
        ),
      ],
    );
  }
}
