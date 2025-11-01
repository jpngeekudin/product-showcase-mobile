import 'package:flutter/material.dart';
import 'package:product_showcase/helpers/dio_helper.dart';
import 'package:product_showcase/helpers/storage_helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      final response = await dio.post('/auth/login', data: {
        'username': _usernameController.text,
        'password': _passwordController.text
      });
      await setStorageStringItem(
          'token', response.data['data']['token']['access_token']);
      await setStorageJsonItem('user', response.data['data']['user']);
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (err) {
      print(err);
    }
  }

  void _checkLoggedInUser() async {
    try {
      final user = await getStorageJsonItem('user');
      if (user != null) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

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
            TextField(
              onChanged: (value) {
                setState(() {
                  _usernameController.text = value; // Update the state variable
                });
              },
            ),
            Container(height: 10),
            const Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _passwordController.text = value; // Update the state variable
                });
              },
            ),
            Container(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // In a real app validate credentials, then navigate
                  _login();
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
