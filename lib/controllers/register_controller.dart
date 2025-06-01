import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class RegisterController {
  static const String _baseUrl = 'http://localhost:8000/api/register'; // Web
  //  static const String _baseUrl = http://10.0.2.2:8000/api/register'; // Android emulador

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Error al registrar',
        };
      }
    } catch (e) {
      debugPrint('Error en registro: $e');
      return {
        'success': false,
        'message': 'Error de conexión',
      };
    }
  }
}
