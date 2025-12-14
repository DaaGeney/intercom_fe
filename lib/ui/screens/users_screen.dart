import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/calls_controller.dart';
import '../../controllers/rooms_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../../models/room.dart';
import '../widgets/user_avatar.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(usersProvider);
    final roomsAsyncValue = ref.watch(roomsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (currentUser != null)
                    Stack(
                      children: [
                        UserAvatar(user: currentUser, size: 40),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.backgroundDark,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'VoiceHub',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppTheme.textPrimary,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: AppTheme.textPrimary,
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search contacts or rooms...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
                  fillColor: AppTheme.cardDark,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
            ),

            const SizedBox(height: 24),

            // Live Voice Rooms Section
            roomsAsyncValue.when(
              data: (rooms) {
                if (rooms.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Live Voice Rooms',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See All >',
                                style: TextStyle(color: AppTheme.primaryBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            return _buildRoomCard(context, ref, room);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Recent Calls Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Recent Calls',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildToggleButton(context, 'All', true),
                              _buildToggleButton(context, 'Missed', false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: usersAsyncValue.when(
                      data: (users) {
                        if (users.isEmpty) {
                          return Center(
                            child: Text(
                              'No recent calls',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return _buildRecentCallItem(context, ref, user);
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text('Error: $error', style: TextStyle(color: AppTheme.danger)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to start new call
        },
        child: const Icon(Icons.add_call, size: 28),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.textPrimary : AppTheme.textTertiary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, WidgetRef ref, Room room) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.volume_up,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.liveIndicator,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            room.name,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${room.participants.length} participants',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/rooms/${room.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text('Join'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCallItem(BuildContext context, WidgetRef ref, User user) {
    final callStatus = user.status == 'online' ? 'Incoming' : 'Outgoing';
    final callTime = '2 min ago'; // TODO: Get actual call time
    final callIcon = callStatus == 'Incoming'
        ? Icons.arrow_downward
        : Icons.arrow_upward;
    final callIconColor = callStatus == 'Incoming'
        ? AppTheme.success
        : AppTheme.primaryBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              UserAvatar(user: user, size: 48),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: callIconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    callIcon,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$callStatus • $callTime',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            color: AppTheme.primaryBlue,
            onPressed: () async {
              final currentUser = ref.read(currentUserProvider);
              if (currentUser == null) return;

              try {
                await ref.read(callsProvider.notifier).startCall(currentUser.id, user.id);
                final call = ref.read(callsProvider);
                if (call != null && context.mounted) {
                  context.push('/call/${call.id}');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to start call: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
