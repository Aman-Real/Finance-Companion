import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/transaction_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_card.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  String type = 'expense';
  String category = 'General';
  final categories = const [
    'General',
    'Groceries',
    'Food & Dining',
    'Transport',
    'Bills',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        elevation: 0,
        backgroundColor: AppColors.card,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s),
            const Text(
              'Track your expenses and income easily',
              style: TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.l),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '${settings.getCurrencySymbol()} 1,250',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'Type',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Row(
                    children: [
                      _typeChip('expense', Icons.remove_circle_outline),
                      const SizedBox(width: AppSpacing.s),
                      _typeChip('income', Icons.add_circle_outline),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      if (value != null) category = value;
                    }),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'Notes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Weekly vegetables and fruits',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isEmpty) return;
                provider.addTransaction(
                  TransactionModel(
                    amount: double.tryParse(amountController.text) ?? 0,
                    type: type,
                    category: category,
                    date: DateTime.now(),
                    note: noteController.text,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String value, IconData icon) {
    final selected = type == value;
    return ChoiceChip(
      label: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: selected ? Colors.white : AppColors.mutedText,
          ),
          const SizedBox(width: 6),
          Text(
            value.capitalize(),
            style: TextStyle(
              color: selected ? Colors.white : AppColors.mutedText,
            ),
          ),
        ],
      ),
      selected: selected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.card,
      onSelected: (_) => setState(() => type = value),
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
