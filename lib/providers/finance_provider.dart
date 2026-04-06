import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/hive_service.dart';

class FinanceProvider extends ChangeNotifier {
  final box = HiveService.getBox();

  List<TransactionModel> get transactions => box.values.toList();

  void addTransaction(TransactionModel tx) {
    box.add(tx);
    notifyListeners();
  }

  void deleteTransaction(int index) {
    box.deleteAt(index);
    notifyListeners();
  }

  double get totalIncome => transactions
      .where((tx) => tx.type == 'income')
      .fold(0, (sum, tx) => sum + tx.amount);

  double get totalExpense => transactions
      .where((tx) => tx.type == 'expense')
      .fold(0, (sum, tx) => sum + tx.amount);

  Map<String, double> get categoryData {
    final Map<String, double> data = {};
    for (final tx in transactions.where((tx) => tx.type == 'expense')) {
      data.update(
        tx.category,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }
    return data;
  }

  double get balance => totalIncome - totalExpense;
}
