import 'package:flutter/material.dart';
import 'package:expenser/models/expense.dart';
import 'package:provider/provider.dart';
import 'package:expenser/providers/list_provider.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({super.key});
  @override
  State<StatefulWidget> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  theCategory? _selectedCategory;
  DateTime? date1;
  DateTime? date2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: const Text('Filter your expenses'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              contentPadding: const EdgeInsets.all(6),
              title: const Text('Current day'),
              subtitle: const Text('Show daily expenses.'),
              trailing: context.watch<ListProvider>().dailyExpense
                  ? TextButton.icon(
                      label: const Text('Click to remove filter'),
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        context.read<ListProvider>().getDailyExpenses();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Daily expenses filter removed!'),
                          ),
                        );
                      },
                    )
                  : TextButton.icon(
                      label: const Text('Click to select'),
                      icon: const Icon(Icons.calendar_today_sharp),
                      onPressed: () {
                        context.read<ListProvider>().getDailyExpenses();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Daily expenses filter applied!'),
                          ),
                        );
                      },
                    )),
          ListTile(
            contentPadding: const EdgeInsets.all(6),
            title: const Text('Current week'),
            subtitle: const Text('Show weekly expenses.'),
            trailing: context.watch<ListProvider>().weeklyExpense
                ? TextButton.icon(
                    label: const Text('Click to remove filter'),
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      context.read<ListProvider>().getWeeklyExpenses();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Weekly expenses filter removed!'),
                        ),
                      );
                    },
                  )
                : TextButton.icon(
                    label: const Text('Click to select'),
                    icon: const Icon(Icons.calendar_view_week_sharp),
                    onPressed: () {
                      context.read<ListProvider>().getWeeklyExpenses();
                      // context.read<ListProvider>().toggleWeeklyExpense();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Weekly expenses filter applied!'),
                        ),
                      );
                    },
                  ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(6),
            title: const Text('Current month'),
            subtitle: const Text('Show monthly expenses.'),
            trailing: context.watch<ListProvider>().monthlyExpense
                ? TextButton.icon(
                    label: const Text('Click to select'),
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      context.read<ListProvider>().getMonthlyExpenses();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Monthly expenses filter removed!'),
                        ),
                      );
                    },
                  )
                : TextButton.icon(
                    label: const Text('Click to select'),
                    icon: const Icon(Icons.calendar_view_month_sharp),
                    onPressed: () {
                      context.read<ListProvider>().getMonthlyExpenses();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Monthly expenses filter applied!'),
                        ),
                      );
                    },
                  ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(6),
            title: const Text('By category'),
            subtitle: const Text('Show expenses by category.'),
            trailing: context.watch<ListProvider>().categoryExpense
                ? TextButton.icon(
                    onPressed: () {
                      context.read<ListProvider>().getExpensesByCategory();
                    },
                    label: Text('${_selectedCategory!.name}'),
                    icon: const Icon(Icons.check),
                  )
                : DropdownButton(
                    hint: const Text('Select category'),
                    value: _selectedCategory,
                    items: theCategory.values
                        .map<DropdownMenuItem<theCategory>>(
                            (theCategory category) {
                      return DropdownMenuItem<theCategory>(
                        value: category,
                        child: Text(
                          category.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                      context
                          .read<ListProvider>()
                          .getExpensesByCategory(value!);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category filter applied!'),
                        ),
                      );
                    },
                  ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(6),
            title: const Text('By date range'),
            subtitle: const Text('Show expenses in date range.'),
            trailing: context.watch<ListProvider>().dateRangeExpense
                ? TextButton.icon(
                    onPressed: () {
                      context.read<ListProvider>().getDateRangeExpenses();
                    },
                    label: Text(
                        'From ${date1.toString().split(' ').first} to ${date2.toString().split(' ').first}\nClick to remove'),
                    icon: const Icon(Icons.check),
                  )
                : TextButton.icon(
                    icon: const Icon(Icons.edit_calendar_sharp),
                    label: const Text('Click to select date'),
                    onPressed: () async {
                      final now = DateTime.now();
                      final firstDate =
                          DateTime(now.year - 1, now.month, now.day);
                      final lastDate = DateTime(now.year, now.month, now.day);
                      final fromDate = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: firstDate,
                          lastDate: lastDate);
                      final toDate = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: firstDate,
                          lastDate: lastDate);
                      date1 = fromDate;
                      date2 = toDate;
                      context
                          .read<ListProvider>()
                          .getDateRangeExpenses(fromDate!, toDate!);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('DateRange expenses filter applied!.'),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.background),
              ),
              onPressed: () {
                context.read<ListProvider>().removeFilters();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have removed all filters.'),
                  ),
                );
              },
              child: const Text(
                'Remove all filters',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
