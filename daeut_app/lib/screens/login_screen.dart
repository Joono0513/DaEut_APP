import 'package:daeut_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _performLogin(UserProvider userProvider) async {
    // 여기에 실제 로그인 로직을 구현
    String username = _usernameController.text;
    String password = _passwordController.text;

    print('Username: $username');
    print('Password: $password');

    await userProvider.login(username, password);
    if (userProvider.isLogin) {
      print('로그인 여부 : ${userProvider.isLogin}');
      await userProvider.getUserInfo();
      print('유저정보 저장 완료...');
      print(userProvider.userInfo);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('로그인', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text('계정에 사용될 정보를 입력해주세요'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '아이디 입력',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 입력',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performLogin(userProvider);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 배경색
                  foregroundColor: Colors.white, // 폰트색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 테두리 곡률
                  ),
                  minimumSize: const Size(double.infinity, 40.0), // 버튼의 최소 크기 - 가로, 세로 크기
                ),
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
