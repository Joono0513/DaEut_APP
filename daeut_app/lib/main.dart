import 'package:daeut_app/main_screen.dart';
import 'package:daeut_app/reservation/list_screen.dart';
import 'package:daeut_app/screens/insert_screen.dart';
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
        '/main': (context) => const MainScreen(),
        '/reservation/list': (context) => const ListScreen(),
      },
    );
  }
}
