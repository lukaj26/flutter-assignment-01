import 'package:expenser/models/expense.dart';
import 'package:expenser/providers/controller_provider.dart';
import 'package:expenser/widgets/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenser/providers/list_provider.dart';

class ExpenseItem extends StatelessWidget {
  ExpenseItem({super.key, this.index});

  final int? index;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    late Expense expense;
    if (args != null) {
      if (args['index'] != null) {
        expense = context.watch<ListProvider>().expenseList[args['index']];
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: const Text('Expense details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense title: ${expense.name}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Amount spent: ${expense.amount} \$',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Description of expense: ${expense.description}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Expense category: ${expense.category.name}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Expense date: ${expense.expenseDate.toString().split(' ').first}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 120,
                ),
                TextButton.icon(
                  onPressed: () {
                    print(" THIS IS THE EXPENSE  ${expense.id}");
                    context.read<ControllerProvider>().disableCreating();
                    context.read<ControllerProvider>().loadExpense(expense);
                    print(" THIS IS THE EXPENSE ID BEING PASSED ${expense.id}");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddExpense(expenseId: expense.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit this expense',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<ListProvider>().removeFromList(expense);
                  },
                  child: const Text(
                    'Delete this expense',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
