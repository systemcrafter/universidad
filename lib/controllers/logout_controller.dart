import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LogoutController {
  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    debugPrint('Token logout: $token');

    if (token == null) return false;

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/logout'), // Web
      // Uri.parse('http://10.0.2.2:8000/api/logout'), // Android emulador

      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    debugPrint('Respuesta logout: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode == 200) {
      await prefs.remove('auth_token');
      return true;
    }

    return false;
  }
}
