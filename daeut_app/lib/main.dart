import 'package:daeut_app/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daeut_app/provider/user_provider.dart';
import 'package:daeut_app/screens/join_screen.dart';
import 'package:daeut_app/screens/login_screen.dart';
import 'package:daeut_app/screens/home_screen.dart';
import 'package:daeut_app/screens/list_screen.dart';
import 'package:daeut_app/screens/insert_screen.dart';
import 'package:daeut_app/screens/read_screen.dart';

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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/user/login': (context) => LoginScreen(),
        '/user/join': (context) => const JoinScreen(),
        '/reservation/reservationList': (context) => const ListScreen(),
        '/reservation/reservationRead': (context) => const ReadScreen(),
        '/reservation/reservationInsert': (context) => const InsertScreen(),
        '/reservation/reservationUpdate': (context) => const UpdateScreen(),
      },
    );
  }
}
