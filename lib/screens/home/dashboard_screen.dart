import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final balance = provider.balance;
    final saved = balance > 0 ? balance : 0;
    final goal = 10000.0;
    final progress = (saved / goal).clamp(0.0, 1.0);
    final budgetText = settings.hasBudget
        ? CurrencyFormatter.format(
            settings.budgetLimit,
            symbol: '${settings.getCurrencySymbol()} ',
            locale: settings.currencyLocale,
          )
        : 'No budget set';

    final recentDays = List.generate(
      7,
      (index) => DateTime.now().subtract(Duration(days: 6 - index)),
    );

    bool sameDate(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    final dailyExpenses = recentDays.map((day) {
      return provider.transactions
          .where((tx) => tx.type == 'expense' && sameDate(tx.date, day))
          .fold<double>(0, (sum, tx) => sum + tx.amount);
    }).toList();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedTextColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.mutedText;
    final gridMax =
        (dailyExpenses.isEmpty
            ? 10.0
            : dailyExpenses.reduce((a, b) => a > b ? a : b)) +
        50.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isDark
                        ? Colors.white12
                        : AppColors.primaryLight,
                    child: Icon(
                      Icons.menu,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: TextStyle(fontSize: 16, color: mutedTextColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'HR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(
                      'assets/images/profile_placeholder.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF43B67A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Balance',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      CurrencyFormatter.format(
                        balance,
                        symbol: '${settings.getCurrencySymbol()} ',
                        locale: settings.currencyLocale,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '+12% vs last month',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  Expanded(
                    child: _miniStatCard(
                      context,
                      'Total Income',
                      provider.totalIncome,
                      AppColors.primaryLight,
                      AppColors.primary,
                      Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: _miniStatCard(
                      context,
                      'Total Expense',
                      provider.totalExpense,
                      const Color(0xFFFBEAEA),
                      Colors.red,
                      Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Savings Goal Progress',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFE6F4EA),
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${settings.getCurrencySymbol()} ${saved.toStringAsFixed(0)} / ${settings.getCurrencySymbol()} ${goal.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'Budget limit: $budgetText',
                      style: TextStyle(color: mutedTextColor),
                    ),
                    const SizedBox(height: AppSpacing.l),
                    SizedBox(
                      height: 160,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: gridMax,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                dailyExpenses.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  dailyExpenses[index],
                                ),
                              ),
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primary.withAlpha(46),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: recentDays.map((day) {
                        final label = [
                          'M',
                          'T',
                          'W',
                          'T',
                          'F',
                          'S',
                          'S',
                        ][recentDays.indexOf(day)];
                        return Text(
                          label,
                          style: TextStyle(color: mutedTextColor),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStatCard(
    BuildContext context,
    String title,
    double amount,
    Color background,
    Color textColor,
    IconData icon,
  ) {
    final mutedTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.mutedText;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: AppSpacing.s),
          Text(title, style: TextStyle(color: mutedTextColor)),
          const SizedBox(height: AppSpacing.s),
          Text(
            '₹ ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
