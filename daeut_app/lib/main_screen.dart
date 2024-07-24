import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text("메인화면"),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, "/reservation/list");
              }, 
              child: Text("게시글 목록"),
              style: ElevatedButton.styleFrom (
                backgroundColor: const Color.fromARGB(255, 64, 124, 255), 
                foregroundColor: Colors.white
              ),
              )
            ],q
          ),
        )
    );
  }
}