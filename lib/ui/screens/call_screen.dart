import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/calls_controller.dart';
import '../../controllers/users_controller.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';

class CallScreen extends ConsumerWidget {
  final String callId;

  const CallScreen({super.key, required this.callId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final usersAsync = ref.watch(usersProvider);

    // If call is null (ended) or we don't have a current user, handle gracefully
    if (call == null) {
      // Ideally navigate back, but for now show a "Call Ended" state
      return const Scaffold(
        backgroundColor: AppTheme.callBackground,
        body: Center(child: Text('Call Ended', style: TextStyle(color: Colors.white))),
      );
    }

    // Determine the other user
    User? otherUser;
    if (currentUser != null && usersAsync.hasValue) {
      final otherUserId = call.fromUserId == currentUser.id ? call.toUserId : call.fromUserId;
      otherUser = usersAsync.value!.cast<User?>().firstWhere(
            (u) => u!.id == otherUserId,
            orElse: () => null,
          );
    }

    final displayName = otherUser?.name ?? 'Unknown';
    final statusText = call.status == 'active' ? 'Connected' : 'Calling...';

    return Scaffold(
      backgroundColor: AppTheme.callBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryBlue, size: 16),
          label: const Text('Chats', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 16)),
        ),
        leadingWidth: 100,
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),
          // Main Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 64, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusText,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const Spacer(flex: 2),
          
          // Controls
          Container(
            padding: const EdgeInsets.only(bottom: 48, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlBtn(Icons.mic_off, 'Silenciar', AppTheme.primaryBlue),
                const SizedBox(width: 32),
                _buildControlBtn(Icons.call_end, 'Colgar', AppTheme.danger, size: 72, iconSize: 32, onTap: () {
                   ref.read(callsProvider.notifier).endCall(callId);
                   context.pop();
                }),
                const SizedBox(width: 32),
                _buildControlBtn(Icons.volume_up, 'Altavoz', AppTheme.callControlBackground),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBtn(IconData icon, String label, Color color, {double size = 56, double iconSize = 24, VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
