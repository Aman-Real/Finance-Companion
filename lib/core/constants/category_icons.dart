import 'package:flutter/material.dart';

class CategoryIcons {
  static IconData getIcon(String category) {
    switch (category) {
      case "Food":
        return Icons.fastfood;
      case "Transport":
        return Icons.directions_car;
      case "Shopping":
        return Icons.shopping_bag;
      case "Bills":
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }
}