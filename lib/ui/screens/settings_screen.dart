import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'CUENTA',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: AppTheme.textPrimary),
                  title: const Text('Mi Cuenta'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                  title: const Text('Notificaciones'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'APLICACIÓN',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.volume_up_outlined, color: AppTheme.textPrimary),
              title: const Text('Voz y Video'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.danger),
              title: const Text('Cerrar Sesión', style: TextStyle(color: AppTheme.danger)),
              onTap: () {
                // Implement logout logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
