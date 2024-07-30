import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:daeut_app/provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JWT 토큰'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('사용자 정보'),
            Text('userId : ${userProvider.userInfo.userId ?? '없음'}'),
            Text('name : ${userProvider.userInfo.userName ?? '없음'}'),
            Text('email : ${userProvider.userInfo.userEmail ?? '없음'}'),
            Text('JWT Token: ${userProvider.isLogin ? '있음' : '없음'}'),
            !userProvider.isLogin
                ? ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/user/login');
                    },
                    child: const Text('로그인'),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await userProvider.logout();
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text('로그아웃'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/reservation/reservationList');
                        },
                        child: const Text('예약 목록 보기'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
