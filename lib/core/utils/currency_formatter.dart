import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(
    double amount, {
    String symbol = '₹ ',
    String locale = 'en_IN',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
