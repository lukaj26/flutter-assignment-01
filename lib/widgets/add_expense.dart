import 'package:flutter/material.dart';
import 'package:expenser/models/expense.dart';
import 'package:expenser/providers/list_provider.dart';
import 'package:expenser/providers/controller_provider.dart';

import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  AddExpense({super.key, this.expenseId});

  String? expenseId;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  // DateTime? _selectedDate;
  // var _selectedCategory = theCategory.food;

  // final _expenseTitleController = TextEditingController();
  // final _expenseDescriptionController = TextEditingController();
  // final _expenseAmountController = TextEditingController();

  // void dispose() {
  //   _expenseTitleController.dispose();
  //   _expenseDescriptionController.dispose();
  //   _expenseAmountController.dispose();
  //   super.dispose();
  // }

  void _presentDatePicker() async {
    if (context.read<ControllerProvider>().expenseDate == null) {
      final now = DateTime.now();
      final firstDate = DateTime(now.year - 1, now.month, now.day);
      final lastDate = DateTime(now.year, now.month, now.day);
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: firstDate,
          lastDate: lastDate);

      context.read<ControllerProvider>().setExpenseDate(pickedDate!);
    } else {
      final now = DateTime.now();
      final firstDate = DateTime(now.year - 1, now.month, now.day);
      final lastDate = DateTime(now.year, now.month, now.day);
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: context.read<ControllerProvider>().expenseDate,
          firstDate: firstDate,
          lastDate: lastDate);
      context.read<ControllerProvider>().setExpenseDate(pickedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register expense'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: context.read<ControllerProvider>().expenseTitle,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                context.read<ControllerProvider>().setExpenseTitle(value);
              },
              decoration: const InputDecoration(
                label: Text('Expense title'),
                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: context.read<ControllerProvider>().expenseDesc,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                context.read<ControllerProvider>().setExpenseDesc(value);
              },
              decoration: const InputDecoration(
                label: Text('Expense description'),
                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: context.read<ControllerProvider>().expenseAmount,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                context.read<ControllerProvider>().setExpenseAmount(value);
              },
              decoration: const InputDecoration(
                label: Text('Expense amount'),
                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                  value: context.watch<ControllerProvider>().expenseCategory,
                  items: theCategory.values.map((category) {
                    return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.toString().split('.').last,
                          style: const TextStyle(color: Colors.white),
                        ));
                  }).toList(),
                  onChanged: (value) {
                    context
                        .read<ControllerProvider>()
                        .setExpenseCategory(value!);
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  label: const Text('Pick a date!'),
                  onPressed: _presentDatePicker,
                  icon: const Icon(
                    Icons.date_range_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            context.read<ControllerProvider>().isCreating
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<ListProvider>().addToList(
                            Expense(
                              name: context
                                  .read<ControllerProvider>()
                                  .expenseTitleController,
                              description: context
                                  .read<ControllerProvider>()
                                  .expenseDescController,
                              amount: context
                                  .read<ControllerProvider>()
                                  .expenseAmountController,
                              expenseDate: context
                                  .read<ControllerProvider>()
                                  .expenseDateController!,
                              category: context
                                  .read<ControllerProvider>()
                                  .expenseCategoryController!,
                            ),
                          );
                    },
                    child: const Text(
                      'Submit expense data',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      context.read<ListProvider>().editExpense(
                            widget.expenseId!,
                            context.read<ControllerProvider>().expenseTitle,
                            context.read<ControllerProvider>().expenseDesc,
                            context.read<ControllerProvider>().expenseAmount,
                            context.read<ControllerProvider>().expenseCategory!,
                            context.read<ControllerProvider>().expenseDate!,
                          );
                      context.read<ControllerProvider>().resetExpenseData();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Done editing',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
