import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daeut_app/provider/user_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false).login(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (Provider.of<UserProvider>(context, listen: false).isLogin) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
