import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_card.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils/currency_formatter.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  double saved = 7000;
  double target = 10000;
  int streakDays = 6;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<SettingsProvider>(context);
    final progress = (saved / target).clamp(0.0, 1.0);
    final formattedSaved = CurrencyFormatter.format(
      saved,
      symbol: '${settings.getCurrencySymbol()} ',
      locale: settings.currencyLocale,
    );
    final formattedTarget = CurrencyFormatter.format(
      target,
      symbol: '${settings.getCurrencySymbol()} ',
      locale: settings.currencyLocale,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Goals'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Savings Goal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$formattedSaved saved',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark
                        ? Colors.white12
                        : const Color(0xFFE6F4EA),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    '$formattedSaved / $formattedTarget saved',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '3 days left in this month',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.mutedText,
                        ),
                      ),
                      Chip(
                        label: const Text('70%'),
                        backgroundColor: AppColors.primaryLight,
                        labelStyle: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'No Spend Challenge',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6 / 7 Days Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'Great job! One more day to complete the challenge.',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Wrap(
                    spacing: AppSpacing.s,
                    children: List.generate(
                      7,
                      (index) => CircleAvatar(
                        radius: 12,
                        backgroundColor: index < streakDays
                            ? AppColors.primary
                            : (isDark
                                  ? Colors.white24
                                  : const Color(0xFFE4E7EF)),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: index < streakDays
                                ? Colors.white
                                : (isDark
                                      ? Colors.white70
                                      : AppColors.mutedText),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'Active Streak',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            CustomCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$streakDays Days',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Keep saving daily to build a longer streak.',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 16,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 1),
                          color: index % 2 == 0
                              ? Colors.black
                              : const Color(0xFFFFC107),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
