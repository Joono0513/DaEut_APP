import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:daeut_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _userInfo = User(); // 기본 초기화
  bool _loginStat = false; // 로그인 상태 기본값
  final storage = const FlutterSecureStorage();

  User get userInfo => _userInfo;
  bool get isLogin => _loginStat;

  // loadUserInfo 메서드 추가
  Future<void> loadUserInfo() async {
    String? token = await storage.read(key: 'jwtToken');
    if (token != null) {
      _loginStat = true;
      await getUserInfo(token);
    }
    notifyListeners();
  }

  Future<void> getUserInfo(String token) async {
    final baseUrl = 'http://10.0.2.2:8080/api/users/info';
    final requestUrl = Uri.parse(baseUrl);
    try {
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
        _userInfo = User.fromJson(result);
      } else {
        _loginStat = false;
      }
    } catch (error) {
      _loginStat = false;
    }
  }

  Future<void> login(String username, String password) async {
    const url = 'http://10.0.2.2:8080/login';
    final requestUrl = Uri.parse('$url?username=$username&password=$password');
    try {
      final response = await http.get(requestUrl);

      if (response.statusCode == 200) {
        final authorizationHeader = response.headers['authorization'];

        if (authorizationHeader != null) {
          final jwtToken = authorizationHeader.replaceFirst('Bearer ', '');
          await storage.write(key: 'jwtToken', value: jwtToken);
          _loginStat = true;
          await getUserInfo(jwtToken);
        }
      }
    } catch (error) {
      _loginStat = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwtToken');
    _userInfo = User();
    _loginStat = false;
    notifyListeners();
  }
}
