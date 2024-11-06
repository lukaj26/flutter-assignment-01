import 'package:flutter/material.dart';
import 'package:expenser/models/expense.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListProvider extends ChangeNotifier {
  List<Expense> expenseList = [];
  List<Expense> filteredExpenseList = [];
  final url = Uri.https(
      'expenser-2-default-rtdb.firebaseio.com', 'expense-tracker.json');

  bool dailyExpense = false;
  bool weeklyExpense = false;
  bool monthlyExpense = false;
  bool categoryExpense = false;
  bool dateRangeExpense = false;

  void removeFilters() {
    dailyExpense = false;
    weeklyExpense = false;
    monthlyExpense = false;
    categoryExpense = false;
    dateRangeExpense = false;
    expenseList = [];
    loadExpenseList();
  }

  bool get isFiltering =>
      dailyExpense ||
      weeklyExpense ||
      monthlyExpense ||
      categoryExpense ||
      dateRangeExpense;

  // void toggleWeeklyExpense() {
  //   if (weeklyExpense) {
  //     weeklyExpense = false;
  //   } else {
  //     weeklyExpense = true;
  //   }
  // }

  // void toggleMonthlyExpense() {
  //   if (monthlyExpense) {
  //     monthlyExpense = false;
  //   } else {
  //     monthlyExpense = true;
  //   }
  // }

  // void toggleDateExpense() {
  //   if (dateRangeExpense) {
  //     dateRangeExpense = false;
  //   } else {
  //     dateRangeExpense = true;
  //   }
  // }

  // void toggleCategoryExpense() {
  //   if (categoryExpense) {
  //     categoryExpense = false;
  //   } else {
  //     categoryExpense = true;
  //   }
  // }

  void getDailyExpenses() {
    dailyExpense = !dailyExpense;
    if (dailyExpense) {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList]
            .where((item) =>
                item.expenseDate.day == DateTime.now().day &&
                item.expenseDate.month == DateTime.now().month &&
                item.expenseDate.year == DateTime.now().year)
            .toList();
      } else {
        filteredExpenseList = [...expenseList]
            .where((item) =>
                item.expenseDate.day == DateTime.now().day &&
                item.expenseDate.month == DateTime.now().month &&
                item.expenseDate.year == DateTime.now().year)
            .toList();
      }
    } else {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList];
      } else {
        filteredExpenseList = [...expenseList];
      }

      // .where((item) =>
      //     item.expenseDate.day == DateTime.now().day &&
      //     item.expenseDate.month == DateTime.now().month &&
      //     item.expenseDate.year == DateTime.now().year)
      // .toList();
    }
    notifyListeners();
  }

  void getWeeklyExpenses() {
    weeklyExpense = !weeklyExpense;
    if (weeklyExpense) {
      // weeklyExpense = false;
      DateTime startOfWeek =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      DateTime endOfWeek = DateTime.now()
          .add(Duration(days: 7 - DateTime.now().weekday)); // Sunday
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList].where((item) {
          return item.expenseDate.isAfter(startOfWeek)
              //item.expenseDate.isAtSameMomentAs(startOfWeek) &&
              &&
              item.expenseDate.isBefore(endOfWeek);
          // || item.expenseDate.isAtSameMomentAs(endOfWeek);
        }).toList();
      } else {
        filteredExpenseList = [...expenseList].where((item) {
          return item.expenseDate.isAfter(startOfWeek)
              // item.expenseDate.isAtSameMomentAs(startOfWeek) &&
              &&
              item.expenseDate.isBefore(endOfWeek); //||
          // item.expenseDate.;
        }).toList();
      }
    } else {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList];
      } else {
        filteredExpenseList = [...expenseList];
      }
    }

    notifyListeners();
  }

  void getMonthlyExpenses() {
    monthlyExpense = !monthlyExpense;
    if (monthlyExpense) {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList]
            .where((item) => (item.expenseDate.month == DateTime.now().month &&
                item.expenseDate.year == DateTime.now().year))
            .toList();
      } else {
        filteredExpenseList = [...expenseList]
            .where((item) => (item.expenseDate.month == DateTime.now().month &&
                item.expenseDate.year == DateTime.now().year))
            .toList();
      }
    } else {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList];
      } else {
        filteredExpenseList = [...expenseList];
      }
    }

    notifyListeners();
  }

  void getExpensesByCategory([theCategory? category]) {
    categoryExpense = !categoryExpense;
    if (categoryExpense) {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList].where((item) {
          return item.category.name == category!.name;
        }).toList();
      } else {
        filteredExpenseList = [...expenseList].where((item) {
          return item.category.name == category!.name;
        }).toList();
      }
    } else {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList];
      } else {
        filteredExpenseList = [...expenseList];
      }
    }

    notifyListeners();
  }

  void getDateRangeExpenses([DateTime? from, DateTime? to]) {
    dateRangeExpense = !dateRangeExpense;

    if (dateRangeExpense) {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList]
            .where((listItem) =>
                listItem.expenseDate.isAfter(from!) &&
                listItem.expenseDate.isBefore(to!))
            .toList();
      } else {
        filteredExpenseList = [...expenseList]
            .where((listItem) =>
                listItem.expenseDate.isAfter(from!) &&
                listItem.expenseDate.isBefore(to!))
            .toList();
      }
    } else {
      if (isFiltering) {
        filteredExpenseList = [...filteredExpenseList];
      } else {
        filteredExpenseList = [...expenseList];
      }
    }

    notifyListeners();
  }

  void addToList(Expense expense) async {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': expense.name,
        'description': expense.description,
        'amount': expense.amount,
        'date': expense.expenseDate.toString(),
        'category': expense.category.name,
      }),
    );
    if (response.statusCode < 400) {
      expenseList.add(expense);
      notifyListeners();
    }
  }

  void removeFromList(Expense expense) async {
    final response = await http.delete(
      Uri.https(
        'expenser-2-default-rtdb.firebaseio.com',
        'expense-tracker/${expense.id}.json',
      ),
    );
    if (response.statusCode == 200) {
      expenseList.remove(expense);
      notifyListeners();
    }
  }

  void loadExpenseList() async {
    final response = await http.get(url);
    if (response.statusCode < 400) {
      Map<String, dynamic> data = json.decode(response.body);
      for (final item in data.entries) {
        expenseList.add(
          Expense(
            id: item.key,
            name: item.value['title'],
            description: item.value['description'],
            amount: item.value['amount'],
            expenseDate: DateTime.parse(item.value['date']),
            category: theCategory.values.firstWhere(
                (theCategory cat) => cat.name == item.value['category']),
          ),
        );
        filteredExpenseList = [...expenseList];
        notifyListeners();
      }
    }
  }

  void editExpense(
      String expenseId,
      String expensename,
      String? expensedescription,
      String expenseamount,
      theCategory expensecategory,
      DateTime expensedatetime) async {
    int expenseIndex = expenseList.indexWhere((item) => (item.id == expenseId));

    Expense tempExpense = Expense(
      id: expenseId,
      name: expensename,
      description: expensedescription,
      amount: expenseamount,
      expenseDate: expensedatetime,
      category: expensecategory,
    );

    expenseList[expenseIndex] = tempExpense;
    // List<Expense> newList = [];

    // for (Expense e in expenseList) {
    //   if (e.id != expenseId) {
    //     newList.add(e);
    //   } else {
    //     newList.add(tempExpense);
    //   }
    // }

    // expenseList = [...newList];

    final response = await http.put(
      Uri.https(
        'expenser-2-default-rtdb.firebaseio.com',
        'expense-tracker/${expenseId}.json',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': tempExpense.name,
        'description': tempExpense.description,
        'amount': tempExpense.amount,
        'date': tempExpense.expenseDate.toString(),
        'category': tempExpense.category.name,
      }),
    );
    if (response.statusCode < 400) {
      notifyListeners();
    } else {
      print('status code je error');
    }

    // tempExpense.description = expensedescription;
    // tempExpense.amount = expenseamount;
    // tempExpense.category = expensecategory;
    // tempExpense.expenseDate = expensedatetime;
  }

  List<Expense> get getList {
    return expenseList;
  }
}
