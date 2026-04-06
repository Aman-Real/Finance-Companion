import 'package:financecompanion/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/constants/category_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_card.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String filter = 'All';
  final filters = const ['All', 'Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<FinanceProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final mutedTextColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.mutedText;
    final transactions = provider.transactions.reversed.toList();
    final filteredTransactions = filter == 'All'
        ? transactions
        : transactions.where((tx) => tx.type == filter.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.cardColor,
        title: const Text('Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              children: filters.map((label) {
                final selected = filter == label;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  backgroundColor: theme.cardColor,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : mutedTextColor,
                  ),
                  onSelected: (_) => setState(() => filter = label),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.m),
            Expanded(
              child: filteredTransactions.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions yet',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredTransactions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.s),
                      itemBuilder: (context, index) {
                        final tx = filteredTransactions[index];
                        return CustomCard(
                          margin: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            tileColor: theme.cardColor,
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: tx.type == 'income'
                                  ? AppColors.primaryLight
                                  : const Color(0xFFFDE8E8),
                              child: Icon(
                                CategoryIcons.getIcon(tx.category),
                                color: tx.type == 'income'
                                    ? AppColors.primary
                                    : Colors.red,
                              ),
                            ),
                            title: Text(
                              tx.category,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              tx.note.isEmpty ? 'No note' : tx.note,
                            ),
                            trailing: Text(
                              CurrencyFormatter.format(
                                tx.amount,
                                symbol: '${settings.getCurrencySymbol()} ',
                                locale: settings.currencyLocale,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: tx.type == 'income'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
