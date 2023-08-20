import 'package:flutter/cupertino.dart';

class NotificationService {
  final budget = ValueNotifier<double>(0.0);

  void updateBudget(double newBudget) {
    budget.value = newBudget;
  }
}