import 'package:flutter/material.dart';
import 'package:expenser/auth_files/auth_service.dart';

// registracija: Name, Surname, email, password
class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  // TODO: Refactor, check comments left on the [LoginScreen], same logic applies, for this whole file
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Register Now'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => _nameController.text += value,
              decoration: const InputDecoration(
                label: Text('Name'),
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
              ),
            ),
            TextField(
              onChanged: (value) => _lastnameController.text += value,
              decoration: const InputDecoration(
                label: Text('Last Name'),
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
              ),
            ),
            // TODO: Missing obscureText
            // TODO: Good practice also is when the user is setting up password for the first time to have 2 fields ,
            // TODO: Password and ConfirmPassword
            TextField(
              controller: _passController,
              decoration: const InputDecoration(
                label: Text('Password'),
                contentPadding: EdgeInsets.only(top: 15, bottom: 15),
              ),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () async {
                final message = await AuthService().registration(email: _emailController.text, password: _passController.text);
                print(_emailController.text);
                print(_passController.text);
                if (message!.contains('Success')) {
                  Navigator.of(context).pushNamed('login');
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => LoginScreen(),
                  //   ),
                  // );
                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text(
                'Submit',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
