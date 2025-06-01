import 'package:flutter/material.dart';
import 'package:universidad/controllers/logout_controller.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final success = await LogoutController.logout();
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cerrar sesión')),
      );
    }
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF27D1C3)),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenid@'),
        backgroundColor: const Color(0xFF27D1C3),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
            ),
            const SizedBox(height: 24),
            _buildButton(
              icon: Icons.person_outline,
              label: 'Información Estudiante',
              onTap: () {},
            ),
            _buildButton(
              icon: Icons.check_circle_outline,
              label: 'Materias Aprobadas',
              onTap: () {},
            ),
            _buildButton(
              icon: Icons.pending_actions,
              label: 'Materias Pendientes',
              onTap: () {},
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27D1C3),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
