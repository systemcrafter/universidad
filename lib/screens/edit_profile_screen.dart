import 'package:flutter/material.dart';
import 'package:universidad/controllers/personal_controller.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const EditProfileScreen({super.key, this.initialData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _careerCtrl = TextEditingController();
  final _birthdayCtrl = TextEditingController();

  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameCtrl.text = widget.initialData!['name'] ?? '';
      _lastNameCtrl.text = widget.initialData!['last_name'] ?? '';
      _birthdayCtrl.text = widget.initialData!['birthday'] ?? '';
      _careerCtrl.text = widget.initialData!['career'] ?? '';
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final result = await PersonalController.saveOrUpdatePersonalInfo(
      name: _nameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      birthday: _birthdayCtrl.text.trim(),
      career: _careerCtrl.text.trim(),
    );

    setState(() => _isSaving = false);

    if (result['success']) {
      Navigator.pop(context, true); // Regresar y recargar en profile_screen
    } else {
      setState(() => _error = result['message']);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _careerCtrl.dispose();
    _birthdayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Información'),
        backgroundColor: const Color(0xFF27D1C3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              _buildTextField(_nameCtrl, 'Nombre'),
              const SizedBox(height: 16),
              _buildTextField(_lastNameCtrl, 'Apellido'),
              const SizedBox(height: 16),
              _buildTextField(
                  _birthdayCtrl, 'Fecha de nacimiento (YYYY-MM-DD)'),
              const SizedBox(height: 16),
              _buildTextField(_careerCtrl, 'Carrera'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27D1C3),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: const Color(0xFFF5FCF9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Ingresa $label' : null,
    );
  }
}
