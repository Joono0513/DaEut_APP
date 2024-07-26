import 'package:daeut_app/screens/insert_screen.dart';
import 'package:daeut_app/screens/read_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daeut_app/provider/user_provider.dart';
import 'package:daeut_app/screens/join_screen.dart';
import 'package:daeut_app/screens/login_screen.dart';
import 'package:daeut_app/screens/home_screen.dart'; // 추가

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT 토큰 로그인',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/main',
      routes: {
        '/main': (context) => MainScreen(),
        '/home': (context) => HomeScreen(),
        '/user/login': (context) => LoginScreen(),
        '/user/join': (context) => JoinScreen(),
        '/reservation/reservationInsert': (context) => InsertScreen(),
        '/reservation/reservationRead': (context) => ReadScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DaEut 1인 가구의 모든 것"),
      ),
      body: TabBarView(
        controller: controller,
        children: const [JoinScreen(), LoginScreen()],
      ),
      bottomNavigationBar: TabBar(
        tabs: const [
          Tab(
            child: Text("회원가입"),
          ),
          Tab(
            child: Text("로그인"),
          ),
        ],
        controller: controller,
      ),
    );
  }
}
