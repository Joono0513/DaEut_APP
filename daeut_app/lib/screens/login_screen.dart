import 'package:daeut_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼 클릭
                _performLogin(userProvider);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }


  // 보류
  void _performLogin(UserProvider userProvider) async {
    // 여기에 실제 로그인 로직을 구현
    String username = _usernameController.text;
    String password = _passwordController.text;

    print('Username: $username');
    print('Password: $password');

    await userProvider.login(username, password);
    if( userProvider.isLogin ) {
      print('로그인 여부 : ${userProvider.isLogin}');
      await userProvider.getUserInfo();
      print('유저정보 저장 완료...');
      print( userProvider.userInfo );
      Navigator.pushReplacementNamed(context, '/');
    }


    
  }
}