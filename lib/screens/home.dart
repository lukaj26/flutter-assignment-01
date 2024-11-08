import 'package:expenser/providers/controller_provider.dart';
import 'package:expenser/providers/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenser/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _error;

  Future<void> _logout(BuildContext context) async {
    // TODO: Commented in the [main.dart], should be refactored.
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove('email');
    sharedPref.remove('password');
    // TODO: pushReplacementNamed only replaced the last item in the navigator stack with the new one,
    // TODO: i.e if there are 3 screens in the stack, and you "logout", if I click back, I go back to those screens, *which are only for logged in users
    // TODO: Google how to clear navigational stack.
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void initState() {
    super.initState();
    context.read<ListProvider>().loadExpenseList();
  }

  List<Expense> localList = [];

  // TODO: For performance it's better to create separate widgets, rather than defining it as a variable
  // TODO: Refactor
  Widget content = const Center(
    child: Text(
      'No expenses added. Try to add some!',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  Future<void> _refreshData() async {
    // TODO: This does nothing, update this part.
    await Future.delayed(const Duration(seconds: 2));
    context.watch<ListProvider>().expenseList;
  }

  @override
  Widget build(BuildContext context) {
    localList = context.watch<ListProvider>().isFiltering
        ? context.watch<ListProvider>().filteredExpenseList
        : context.watch<ListProvider>().expenseList;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: const Text('Expenser'),
        centerTitle: false,
        actions: [
          // TODO: Try to minimize code duplication
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('filter');
            },
            label: const Text('Filter'),
            icon: const Icon(Icons.settings),
          ),
          TextButton.icon(
            onPressed: () async {
              context.read<ControllerProvider>().resetExpenseData();
              Navigator.of(context).pushNamed('addexpense');
            },
            label: const Text('Add'),
            icon: const Icon(Icons.add_card),
          ),
          TextButton.icon(
            onPressed: () async {
              await _logout(context);
            },
            label: const Text('Logout'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // TODO: Is this [Builder] necessary?
      body: Builder(
        builder: (context) {
          if (localList.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                  itemCount: localList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        final removedItem = localList[index];
                        context.read<ListProvider>().removeFromList(localList[index]);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You removed ${removedItem.name}'),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                      ),
                      // TODO: Extract single list item to a custom widget
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        contentPadding: const EdgeInsets.all(5),
                        tileColor: Theme.of(context).colorScheme.onPrimary,
                        // TODO: Not a good thing to use fixed width & height, we only use this for necessary cases.
                        // TODO: This is not one of them, refactor.
                        leading: SizedBox(
                          width: 50,
                          height: 28,
                          child: Text(
                            '\$${localList[index].amount}',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                          ),
                        ),
                        // TODO: Why perform [toString] on a String?
                        title: Text(
                          localList[index].name.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category: ${localList[index].category.name}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Date: ${localList[index].expenseDate.toString().split(' ').first}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                'expenseitem',
                                arguments: {
                                  'index': index,
                                },
                              );
                            },
                            child: const Text(
                              'Show details',
                              style: TextStyle(fontSize: 12),
                            )),
                      ),
                    );
                  }),
            );
          }
          if (_error != null) {
            // TODO: Extract to a custom widget, try to improve the readability of the build i.e Widget tree
            return const Center(
              child: Text(
                'No expenses added yet... Try adding some!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }

          // TODO: Is it a good idea to have loading as a default behaviour?
          // TODO: Consider different approach
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
