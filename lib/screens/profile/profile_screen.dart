import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/custom_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SettingsProvider settingsProvider;

  @override
  void initState() {
    super.initState();
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedTextColor = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.l),
              CustomCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.brightness == Brightness.dark
                          ? Colors.white12
                          : AppColors.primaryLight,
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'USER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'user@finance.com',
                          style: TextStyle(color: mutedTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              Consumer<SettingsProvider>(
                builder: (context, settings, _) => Column(
                  children: [
                    _profileOption(
                      context,
                      icon: Icons.currency_rupee,
                      title: 'Currency',
                      subtitle: settings.currency,
                      onTap: () => _showCurrencyDialog(context),
                    ),
                    _profileOption(
                      context,
                      icon: Icons.credit_card,
                      title: 'Budget Limit',
                      subtitle: settings.hasBudget
                          ? settings.budgetLimitString
                          : 'Set monthly budget',
                      onTap: () => _showBudgetDialog(context),
                    ),
                    _profileOption(
                      context,
                      icon: Icons.notifications,
                      title: 'Reminders',
                      subtitle:
                          '${settings.reminderTimeString} - ${settings.reminderDaysString}',
                      onTap: () => _showRemindersDialog(context),
                    ),
                    _profileOption(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: settings.darkMode ? 'Enabled' : 'Disabled',
                      onTap: () => _showDarkModeToggle(context, settings),
                    ),
                    _profileOption(
                      context,
                      icon: Icons.info,
                      title: 'About the App',
                      subtitle: 'Version 1.0.0',
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              ElevatedButton(
                onPressed: () => _showLogoutConfirmation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    const currencies = ['INR', 'USD', 'EUR', 'GBP'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies
              .map(
                (currency) => RadioListTile<String>(
                  title: Text(currency),
                  value: currency,
                  groupValue: settings.currency,
                  onChanged: (value) {
                    if (value != null) {
                      settings.setCurrency(value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Currency changed to $value')),
                      );
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final budgetController = TextEditingController(
      text: settings.hasBudget ? settings.budgetLimit.toStringAsFixed(0) : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter budget amount',
            prefixText: '${settings.getCurrencySymbol()} ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final limit = double.tryParse(budgetController.text) ?? 0;
              settings.setBudgetLimit(limit);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    limit > 0
                        ? 'Budget set to ${settings.getCurrencySymbol()} ${limit.toStringAsFixed(0)}'
                        : 'Budget cleared',
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showRemindersDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final selectedDays = List<int>.from(settings.reminderDays);
    TimeOfDay selectedTime = settings.reminderTime;
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder:
            (
              BuildContext innerContext,
              void Function(void Function()) setState,
            ) {
              return AlertDialog(
                title: const Text('Set Reminders'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reminder Time:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: dialogContext,
                                  initialTime: selectedTime,
                                );
                                if (time != null) {
                                  setState(() => selectedTime = time);
                                }
                              },
                              icon: const Icon(Icons.access_time),
                              label: Text(
                                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.m),
                      const Text(
                        'Reminder Days:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Column(
                        children: List.generate(daysOfWeek.length, (index) {
                          final day = index + 1;
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(daysOfWeek[index]),
                            value: selectedDays.contains(day),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  selectedDays.add(day);
                                  selectedDays.sort();
                                } else {
                                  selectedDays.remove(day);
                                }
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      settings.setReminderTime(selectedTime);
                      settings.setReminderDays(selectedDays);
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reminders updated')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
      ),
    );
  }

  void _showDarkModeToggle(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dark Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Enable Dark Mode'),
                Switch(
                  value: settings.darkMode,
                  onChanged: (value) {
                    settings.setDarkMode(value);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Dark mode ${value ? 'enabled' : 'disabled'}',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Finance Companion',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Finance Companion. All rights reserved.',
      children: [
        const Text('Track your finances with ease.'),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Income and expense tracking'),
        const Text('• Goal management'),
        const Text('• Spending insights'),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _profileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final mutedTextColor = theme.textTheme.bodyMedium?.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: GestureDetector(
        onTap: onTap,
        child: CustomCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white12
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: mutedTextColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}
