import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../controllers/users_controller.dart';
import '../widgets/user_avatar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: AppTheme.backgroundDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          if (currentUser != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  UserAvatar(user: currentUser, size: 64),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser.status == 'online' ? 'Disponible' : 'Desconectado',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryPurple),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Account Section
          const Text(
            'CUENTA',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: AppTheme.textPrimary),
                  title: const Text(
                    'Mi Cuenta',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 60, color: AppTheme.surfaceDark),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                  title: const Text(
                    'Notificaciones',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Application Section
          const Text(
            'APLICACIÓN',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.volume_up_outlined, color: AppTheme.textPrimary),
              title: const Text(
                'Voz y Video',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 24),

          // Logout
          Container(
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.danger),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: AppTheme.danger),
              ),
              onTap: () {
                ref.read(currentUserProvider.notifier).state = null;
                context.go('/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}
