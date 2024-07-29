import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service.dart';

class ServiceApi {
  static Future<Service> getService(int serviceNo) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/reservation/$serviceNo'));

    if (response.statusCode == 200) {
      var utf8Decoded = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(utf8Decoded);
      print("Service Data: $jsonResponse"); // 디버깅 메시지 추가
      return Service.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load service');
    }
  }
}
