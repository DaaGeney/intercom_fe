import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/calls_controller.dart';
import '../../controllers/users_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../widgets/user_avatar.dart';

class IncomingCallScreen extends ConsumerWidget {
  final String callId;

  const IncomingCallScreen({super.key, required this.callId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final usersAsync = ref.watch(usersProvider);

    // Si la llamada terminó mientras estábamos aquí, regresar
    if (call == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pop();
        }
      });
      return const Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    User? caller;
    if (currentUser != null && usersAsync.hasValue) {
      caller = usersAsync.value!.firstWhere(
        (u) => u.id == call.fromUserId,
        orElse: () => usersAsync.value!.first,
      );
    }

    final callerName = caller?.name ?? 'Unknown';

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Spacer top
            const SizedBox(height: 60),

            // Llamada entrante text
            Text(
              'Llamada entrante',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // Caller avatar
            if (caller != null)
              UserAvatar(user: caller, size: 120)
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: AppTheme.textSecondary,
                ),
              ),

            const SizedBox(height: 24),

            // Caller name
            Text(
              callerName,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Call type
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Llamada de voz',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // CIFRADO banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cardDark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'CIFRADO DE EXTREMO A EXTREMO',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rechazar
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.danger,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.call_end, size: 32),
                          color: Colors.white,
                          onPressed: () async {
                            // Rechazar llamada = terminar llamada
                            await ref.read(callsProvider.notifier).endCall(call.id);
                            if (context.mounted) {
                              context.pop();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rechazar',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Aceptar
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.phone, size: 32),
                          color: Colors.white,
                          onPressed: () {
                            // Aceptar: navegar a CallScreen
                            context.pushReplacement('/call/${call.id}');
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aceptar',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

