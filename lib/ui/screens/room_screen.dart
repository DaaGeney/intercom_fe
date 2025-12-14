import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/rooms_controller.dart';
import '../../controllers/users_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  const RoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    final roomsAsyncValue = ref.watch(roomsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: roomsAsyncValue.when(
          data: (rooms) {
            final room = rooms.firstWhere(
              (r) => r.id == widget.roomId,
              orElse: () => throw Exception('Room not found'),
            );

            final usersAsync = ref.watch(usersProvider);

            return usersAsync.when(
              data: (allUsers) {
                final roomUsers = allUsers.where((u) => room.participants.contains(u.id)).toList();
                final isHost = currentUser != null && roomUsers.isNotEmpty && roomUsers.first.id == currentUser.id;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: AppTheme.textPrimary,
                              onPressed: () => context.pop(),
                            ),
                            const Expanded(
                              child: Text(
                                'Detalles del Grupo',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              color: AppTheme.textPrimary,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      // Room Header Card
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Room Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryPurple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Icon(
                                    Icons.volume_up,
                                    size: 60,
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.liveIndicator,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'EN VIVO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Room Name
                            Text(
                              room.name,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Duration
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  '04:23 transcurrido',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Description (optional)
                            Text(
                              'Discusión semanal sobre diseño de interfaz y experiencia de usuario.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.person_add, size: 18),
                                    label: const Text('Invitar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.cardDark,
                                      foregroundColor: AppTheme.textPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.share, size: 18),
                                    label: const Text('Compartir'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.cardDark,
                                      foregroundColor: AppTheme.textPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Participants Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Participantes (${roomUsers.length})',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Ver todos',
                                style: TextStyle(color: AppTheme.primaryBlue),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Participants Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: roomUsers.take(5).map((user) {
                            final index = roomUsers.indexOf(user);
                            final isSpeaking = index == 0;
                            final isMuted = index == 2;
                            final status = isHost && index == 0
                                ? 'Host'
                                : isSpeaking
                                    ? 'Hablando'
                                    : isMuted
                                        ? 'Silenciado'
                                        : 'Escuchando';

                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    UserAvatar(user: user, size: 64),
                                    if (isSpeaking)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppTheme.primaryBlue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.mic,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else if (isMuted)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppTheme.cardDark,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.mic_off,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isHost && index == 0)
                                  const Text(
                                    '(Host)',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                                );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Group Link Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.link,
                                color: AppTheme.primaryBlue,
                                size: 24,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Enlace del grupo',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Comparte el enlace para que otros se unan rápidamente.',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
                                    foregroundColor: AppTheme.primaryPurple,
                                  ),
                                  child: const Text('Copiar enlace'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Join/Leave Button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (currentUser != null) {
                                    if (_isJoined) {
                                      // Leave logic
                                      setState(() {
                                        _isJoined = false;
                                      });
                                    } else {
                                      ref.read(roomsProvider.notifier).joinRoom(room.id, currentUser.id);
                                      setState(() {
                                        _isJoined = true;
                                      });
                                    }
                                  }
                                },
                                icon: Icon(_isJoined ? Icons.exit_to_app : Icons.mic),
                                label: Text(_isJoined ? 'Salir' : 'Unirse al grupo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isJoined ? AppTheme.danger : AppTheme.primaryBlue,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            if (_isJoined) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isJoined = false;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_forward, color: AppTheme.danger),
                                  label: const Text(
                                    'Salir',
                                    style: TextStyle(color: AppTheme.danger),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(
                child: Text('Error loading users: $e', style: const TextStyle(color: AppTheme.danger)),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error', style: const TextStyle(color: AppTheme.danger)),
          ),
        ),
      ),
    );
  }
}
