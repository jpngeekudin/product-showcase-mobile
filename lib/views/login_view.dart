import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/app_logo.png'),
            Container(height: 12),
            Text('Enter your username and password correctly'),
            Container(height: 32),
            const Text(
              'Username',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(),
            Container(height: 10),
            const Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(obscureText: true),
            Container(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // In a real app validate credentials, then navigate
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
