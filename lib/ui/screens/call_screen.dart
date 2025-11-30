import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/calls_controller.dart';
import '../../theme/app_theme.dart';

class CallScreen extends ConsumerWidget {
  final String callId;

  const CallScreen({super.key, required this.callId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callsProvider);

    // For demo purposes, if call is null, we show a "Connecting..." state or similar
    // instead of immediately exiting, to match the UI design request.
    
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
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
            child: const CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'), // Placeholder
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sofia Rodriguez',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Conectando...',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const Spacer(flex: 2),
          // Participants Row
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildParticipant('Carlos Perez', 'https://i.pravatar.cc/150?img=11', isMuted: true),
                const SizedBox(width: 24),
                _buildParticipant('Ana Diaz', null, isMuted: true, initials: 'AD'),
                const SizedBox(width: 24),
                _buildParticipant('Miguel Silva', 'https://i.pravatar.cc/150?img=59', isSpeaking: true),
              ],
            ),
          ),
          const Spacer(),
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

  Widget _buildParticipant(String name, String? imgUrl, {bool isMuted = false, bool isSpeaking = false, String? initials}) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppTheme.callControlBackground,
              backgroundImage: imgUrl != null ? NetworkImage(imgUrl) : null,
              child: imgUrl == null ? Text(initials ?? '', style: const TextStyle(color: Colors.white, fontSize: 20)) : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isMuted ? AppTheme.danger : (isSpeaking ? AppTheme.success : AppTheme.callControlBackground),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.callBackground, width: 2),
                ),
                child: Icon(
                  isMuted ? Icons.mic_off : (isSpeaking ? Icons.mic : Icons.mic_none),
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
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
