import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/rooms_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/user_list_item.dart';

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  const RoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    final roomsAsyncValue = ref.watch(roomsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Voice Channel'),
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        titleTextStyle: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: roomsAsyncValue.when(
        data: (rooms) {
          final room = rooms.firstWhere(
            (r) => r.id == widget.roomId,
            orElse: () => throw Exception('Room not found'),
          );

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primaryBlue,
                      child: Icon(Icons.volume_up, size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${room.users.length} active participants',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Join room logic
                      },
                      icon: const Icon(Icons.add_call),
                      label: const Text('Join Voice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: room.users.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = room.users[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      child: UserListItem(user: user),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
