import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  String _currency = 'INR';
  bool _darkMode = false;
  double _budgetLimit = 0.0;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  List<int> _reminderDays = [DateTime.friday]; // 1-7 for Mon-Sun

  String get currency => _currency;
  bool get darkMode => _darkMode;
  double get budgetLimit => _budgetLimit;
  bool get hasBudget => _budgetLimit > 0;
  TimeOfDay get reminderTime => _reminderTime;
  List<int> get reminderDays => _reminderDays;

  String get reminderTimeString {
    final hour = _reminderTime.hour.toString().padLeft(2, '0');
    final minute = _reminderTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get reminderDaysString {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    if (_reminderDays.isEmpty) return 'No reminders';
    if (_reminderDays.length == 7) return 'Daily';
    return _reminderDays.map((day) => days[day - 1]).join(', ');
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _darkMode = isDark;
    notifyListeners();
  }

  void setBudgetLimit(double limit) {
    _budgetLimit = limit;
    notifyListeners();
  }

  String get budgetLimitString {
    if (_budgetLimit <= 0) return 'No budget set';
    return '${getCurrencySymbol()} ${_budgetLimit.toStringAsFixed(0)}';
  }

  String get currencyLocale {
    switch (_currency) {
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'en_IE';
      case 'GBP':
        return 'en_GB';
      case 'INR':
      default:
        return 'en_IN';
    }
  }

  void setReminderTime(TimeOfDay time) {
    _reminderTime = time;
    notifyListeners();
  }

  void setReminderDays(List<int> days) {
    _reminderDays = days;
    notifyListeners();
  }

  void toggleReminderDay(int day) {
    if (_reminderDays.contains(day)) {
      _reminderDays.remove(day);
    } else {
      _reminderDays.add(day);
    }
    _reminderDays.sort();
    notifyListeners();
  }

  String getCurrencySymbol() {
    switch (_currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'INR':
      default:
        return '₹';
    }
  }
}
