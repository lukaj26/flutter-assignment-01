import 'package:expenser/auth_files/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Consider naming convention of the file, currently it's [login.dart]
// TODO: but it should be more human friendly, easiest way is to suffix with file's type
// e.g [login_view.dart], [register_view]
// My practice is to match class name with the file, for easier navigation through classes and files in the future,
// e.g login_view holds [LoginView] widget
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // TODO: This is not the wanted solution. HINT:
  // We can create a provider for handling the [LoginScreen] logic,
  // this enables you to handle error, success and loading states more easily.
  // TODO: Refactor the code to handle the [email] & [password] fields inside a provider.
  // HINT: Lookup [onChanged] method in [TextFormField] or [TextField]
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    // TODO: Controllers are instantiated in [initState], it's more optimal due to some
    // TODO: memory stuff, not too important at the moment, but if you are using any controller,
    // TODO: initiate it in the [initState].
    super.initState();
  }

  // TODO: If we do not use the @override macro, this won't be called.
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // TODO: Implement a custom widget for text fields to minimize code duplication.
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _emailController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                label: Text('Email'),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              controller: _passController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                label: Text('Password'),
              ),
            ),
            const SizedBox(height: 30),
            // TODO: Implement a custom widget for button to minimize code duplication.
            FilledButton.icon(
              onPressed: () async {
                // TODO: We do not want to see any logic inside the UI.
                // HINT: Consider the comments above to refactor this code as well.
                final message = await AuthService().login(email: _emailController.text, password: _passController.text);
                if (message!.contains('Success')) {
                  final sharedPref = await SharedPreferences.getInstance();
                  sharedPref.setString('email', _emailController.text);
                  sharedPref.setString('password', _passController.text);
                  Navigator.of(context).pushReplacementNamed('home');
                } else {
                  // HINT: When using showSnackBar, always hide any previously visible snackBar,
                  /* This is how it should be used, if unclear what the [..] operator is
                  google : Cascade operator dart

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Login failed. Please try again.'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                   */

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login failed. Please try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.lock_open),
              label: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: () {
                // TODO: It's not good practice to hardcode route names, this can easily lead to typos
                // TODO: when working with large projects, good idea would be to declared route names in one place, and then call upon that.
                // TODO: Refactor.
                Navigator.of(context).pushNamed('registration');
              },
              child: Text(
                'Don\'t have an account? Register here.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
