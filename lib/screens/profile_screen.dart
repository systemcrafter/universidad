import 'package:flutter/material.dart';
import 'package:universidad/controllers/personal_controller.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await PersonalController.fetchPersonalInfo();

    if (result['success']) {
      setState(() {
        _data = result['data'];
        _loading = false;
      });
    } else {
      setState(() {
        _error = result['message'] ?? 'No hay datos disponibles.';
        _loading = false;
      });
    }
  }

  void _goToEditScreen() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(initialData: _data)),
    );

    if (updated == true) {
      _loadData(); // Recargar datos si se actualizó
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Estudiante'),
        backgroundColor: const Color(0xFF27D1C3),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : _data == null
                  ? const Center(
                      child: Text(
                        'No hay información personal registrada.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person,
                              size: 100, color: Color(0xFF27D1C3)),
                          const SizedBox(height: 20),
                          _buildField('Nombre', _data!['name']),
                          _buildField('Apellido', _data!['last_name']),
                          _buildField(
                              'Fecha de nacimiento', _data!['birthday']),
                          _buildField('Carrera', _data!['career']),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: _goToEditScreen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF27D1C3),
                                shape: const StadiumBorder(),
                                minimumSize: const Size(200, 45),
                              ),
                              child: const Text('Editar información'),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        '$label: ${value ?? "No disponible"}',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
