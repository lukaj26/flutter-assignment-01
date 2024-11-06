import 'package:expenser/auth_files/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
            FilledButton.icon(
              onPressed: () async {
                final message = await AuthService().login(
                    email: _emailController.text,
                    password: _passController.text);
                if (message!.contains('Success')) {
                  final sharedPref = await SharedPreferences.getInstance();
                  sharedPref.setString('email', _emailController.text);
                  sharedPref.setString('password', _passController.text);
                  Navigator.of(context).pushReplacementNamed('home');
                } else {
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
