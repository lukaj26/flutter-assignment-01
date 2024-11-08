import 'package:expenser/providers/list_provider.dart';
import 'package:expenser/screens/filter.dart';
import 'package:expenser/screens/home.dart';
import 'package:expenser/screens/registration.dart';
import 'package:expenser/widgets/add_expense.dart';
import 'package:expenser/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expenser/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:expenser/providers/controller_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expenser/auth_files/auth_service.dart';

// TODO: Export theme in a separate file
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 0, 131, 107),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? message;
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  // TODO: Do not save email & password, passwords must not be saved at any times!!!
  // TODO: Refactor the code to only save the [AuthToken] or [AuthSession]
  // TODO: Check [Firebase] response to find it.
  final String? email = sharedPref.getString('email');
  final String? password = sharedPref.getString('password');
  if (email != null && password != null) {
    message = await AuthService().login(email: email, password: password);
  }
  await Firebase.initializeApp();
  runApp(MyApp(
    message: message,
  ));
}

// TODO: [main.dart] should only contain main method, export [MyApp]
class MyApp extends StatelessWidget {
  MyApp({super.key, required this.message});
  String? message;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerProvider(),
        ),
      ],
      child: MaterialApp(
        initialRoute: message == null ? '/' : 'home',
        // TODO: Consider extracting all named routes in a separate file.
        // e.g we can have a [routes.dart] which holds all this logic, so that we do not crowd the [app.dart]
        routes: {
          '/': (context) => LoginScreen(),
          'home': (context) => HomeScreen(),
          'filter': (context) => FilterScreen(),
          'addexpense': (context) => AddExpense(),
          'expenseitem': (context) => ExpenseItem(),
          'registration': (context) => RegistrationScreen(),
        },
        theme: theme,
      ),
    );
  }
}
