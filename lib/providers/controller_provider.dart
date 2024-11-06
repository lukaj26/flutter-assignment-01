import 'package:expenser/models/expense.dart';
import 'package:flutter/material.dart';

class ControllerProvider extends ChangeNotifier {
  String expenseTitleController = "";
  String? expenseDescController = "";
  String expenseAmountController = "";
  theCategory? expenseCategoryController = theCategory.food;
  DateTime? expenseDateController;
  bool isCreating = true;
  String get expenseTitle => expenseTitleController;

  String? get expenseDesc => expenseDescController;

  String get expenseAmount => expenseAmountController;

  theCategory? get expenseCategory => expenseCategoryController;

  DateTime? get expenseDate => expenseDateController;

  void resetExpenseData() {
    expenseTitleController = "";
    expenseDescController = "";
    expenseAmountController = "";
    expenseCategoryController = theCategory.food;
    expenseDateController = null;
    isCreating = true;
    notifyListeners();
  }

  void setExpenseTitle(String titleText) {
    expenseTitleController = titleText;
    notifyListeners();
  }

  void setExpenseDesc(String? descText) {
    expenseDescController = descText;
    notifyListeners();
  }

  void setExpenseAmount(String amountText) {
    expenseAmountController = amountText;
    notifyListeners();
  }

  void setExpenseCategory(theCategory category) {
    expenseCategoryController = category;
    notifyListeners();
  }

  void setExpenseDate(DateTime expenseDate) {
    expenseDateController = expenseDate;
    notifyListeners();
  }

  void disableCreating() {
    isCreating = false;
    notifyListeners();
  }

  void loadExpense(Expense expense) {
    setExpenseTitle(expense.name);
    setExpenseDesc(expense.description);
    setExpenseAmount(expense.amount);
    setExpenseCategory(expense.category);
    setExpenseDate(expense.expenseDate);
  }
}
