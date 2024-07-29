import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service.dart';

class ServiceApi {
  static const String baseUrl = "http://10.0.2.2:8080";

  static Future<Service> getService(int serviceNo) async {
    final response = await http.get(Uri.parse('$baseUrl/reservation/$serviceNo'));

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load service');
    }
  }
}
