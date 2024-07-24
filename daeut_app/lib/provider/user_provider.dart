import 'dart:convert';

import 'package:daeut_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  // 로그인 정보
  User _userInfo = User(); // Default initialization

  // 로그인 상태
  bool _loginStat = false;

  // getter
  User get userInfo => _userInfo;
  bool get isLogin => _loginStat;

  final storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    const url = 'http://10.0.2.2:8080/login';
    final requestUrl = Uri.parse('$url?username=$username&password=$password');
    try {
      final response = await http.get(requestUrl);

      if (response.statusCode == 200) {
        print('로그인 성공...');
        final authorizationHeader = response.headers['authorization'];

        if (authorizationHeader != null) {
          final jwtToken = authorizationHeader.replaceFirst('Bearer ', '');
          print('JWT Token: $jwtToken');
          await storage.write(key: 'jwtToken', value: jwtToken);
          _loginStat = true;
        } else {
          print('Authorization 헤더가 없습니다.');
        }
      } else if (response.statusCode == 403) {
        print('아이디 또는 비밀번호가 일치하지 않습니다...');
      } else {
        print('네트워크 오류 또는 알 수 없는 오류로 로그인에 실패하였습니다...');
      }
    } catch (error) {
      print("로그인 실패 $error");
    }
    notifyListeners();
  }

  Future<void> getUserInfo() async {
    final baseUrl = 'http://10.0.2.2:8080/api/users/info';
    final requestUrl = Uri.parse(baseUrl);
    try {
      String? token = await storage.read(key: 'jwtToken');
      print('사용자 정보 요청 전: jwt - $token');

      final response = await http.get(
        requestUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var utf8Decoded = utf8.decode(response.bodyBytes);
        var result = json.decode(utf8Decoded);
        final userInfo = result;
        print('User Info: $userInfo');

        _userInfo = User.fromJson(userInfo);
        print(_userInfo);
        print('유저정보 저장 완료...');
      } else {
        print('HTTP 요청 실패: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await storage.delete(key: 'jwtToken');
      _userInfo = User();
      _loginStat = false;
      print('로그아웃 성공');
    } catch (error) {
      print('로그아웃 실패');
    }
    notifyListeners();
  }
}
