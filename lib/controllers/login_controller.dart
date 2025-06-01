import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  // static const String _baseUrl =
  //'http://10.0.2.2:8000/api/login'; // Android emulador
  static const String _baseUrl = 'http://localhost:8000/api/login'; // Web

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(_baseUrl);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        debugPrint('Token login: $token');

        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString(
            'user_name', user['name']); // 👈 Aquí guardamos el nombre

        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Credenciales incorrectas',
        };
      } else {
        return {
          'success': false,
          'message': 'Error inesperado (${response.statusCode})',
        };
      }
    } catch (e) {
      debugPrint('Error en login: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
