import 'package:daeut_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // FlutterSecureStorage : 안전한 저장소
  final storage = const FlutterSecureStorage();
  String jwtToken = "";

  @override
  void initState() {
    super.initState();

    loadJwtToken();
  }

  /**
   * 💍 저장된 JWT 토큰 읽어오기
   */
  Future<void> loadJwtToken() async {
    // 저장된 JWT 토큰 읽기
    String? token = await storage.read(key: 'jwtToken');
    
    // 저장된 토큰이 없으면 ➡ 로그인 화면으로
    if( token == null || token == '' ) {
      print('미리 저장된 jwt 토큰 없음');
      print('로그인 화면으로 이동...');
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    // 저장된 토큰이 있으면 ➡ 서버로 사용자 정보 요청

    setState(() {
      jwtToken = token ?? "";
    });
  }

  Future<void> saveJwtToken(String token) async {
    await storage.write(key: 'jwtToken', value: token);
  }

  @override
  Widget build(BuildContext context) {
    // listen: (provider 구독여부)
    // - true : provider 에서 notifyListeners() 호출 시, consumer 리렌더링 ⭕
    // - false : provider 에서 notifyListeners() 호출 시, consumer 리렌더링 ❌
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('JWT 토큰'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('사용자 정보'),
            Text('userId : ${userProvider.userInfo.userId ?? '없음'}'),
            Text('name : ${userProvider.userInfo.userName ?? '없음'}'),
            Text('email : ${userProvider.userInfo.userEmail ?? '없음'}'),
            Text('JWT Token: $jwtToken'),
            !userProvider.isLogin ? 
                ElevatedButton(
                  onPressed: () async {
                    print('로그인 화면으로 이동...');
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('로그인'),
                )
              :
                ElevatedButton(
                  onPressed: () async {
                    print('로그아웃 처리...');
                    userProvider.logout();
                  },
                  child: Text('로그아웃'),
                ),
          ],
        ),
      ),
    );
  }
  
}