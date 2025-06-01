import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PersonalController {
  static const String _url = 'http://localhost:8000/api/personal-info';
  // Para Android emulador sería: 'http://10.0.2.2:8000/api/personal-info';

  // Obtener la información personal del usuario
  static Future<Map<String, dynamic>> fetchPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return {'success': false, 'message': 'Token no encontrado'};
    }

    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': 'Error ${response.statusCode}: ${response.body}'
      };
    }
  }

  // Guardar o actualizar la información personal del usuario
  static Future<Map<String, dynamic>> saveOrUpdatePersonalInfo({
    required String name,
    required String lastName,
    required String birthday,
    required String career,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return {'success': false, 'message': 'Token no encontrado'};
    }

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'last_name': lastName,
        'birthday': birthday,
        'career': career,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      return {
        'success': false,
        'message': 'Error ${response.statusCode}: ${response.body}'
      };
    }
  }
}
