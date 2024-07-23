import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckDuplicateService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<bool> checkDuplicateId(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/check-duplicate?userId=$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['exists'];
    } else {
      throw Exception('Failed to check duplicate ID');
    }
  }

  static Future<bool> checkDuplicateEmail(String userEmail) async {
    final response = await http.get(Uri.parse('$baseUrl/check-duplicate-email?userEmail=$userEmail'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['exists'];
    } else {
      throw Exception('Failed to check duplicate email');
    }
  }

  static Future<String> join(Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/join'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(formData),
    );
    if (response.statusCode == 200) {
      return 'SUCCESS';
    } else {
      return 'FAIL';
    }
  }
}
