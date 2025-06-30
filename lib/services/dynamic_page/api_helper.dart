import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';

class ApiHelper {
  // Build headers with auth token
  static Future<Map<String, String>> httpHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'authorization': 'Bearer $token',
    };
  }

  // GET request
  static Future<dynamic> get(String route,
      {Map<String, dynamic>? params}) async {
    final headers = await httpHeader();
    Uri uri = Uri.parse('${appConfig.apiBaseUrl}/api/$route');
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
    }
    final response = await http.get(uri, headers: headers);
    return jsonDecode(response.body);
  }

  // POST request
  static Future<dynamic> post(String route, Map<String, dynamic> data) async {
    final headers = await httpHeader();
    Uri uri = Uri.parse('${appConfig.apiBaseUrl}/api/$route');
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return jsonDecode(response.body);
  }

  // DELETE request
  static Future<dynamic> delete(String route,
      {Map<String, dynamic>? params}) async {
    final headers = await httpHeader();
    Uri uri = Uri.parse('${appConfig.apiBaseUrl}/api/$route');
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
    }
    final response = await http.delete(uri, headers: headers);
    return jsonDecode(response.body);
  }
}
