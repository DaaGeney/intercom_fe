import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/calls_controller.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/livekit_controller.dart';
import '../../services/api_service.dart';
import '../../config.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../widgets/user_avatar.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String callId;

  const CallScreen({super.key, required this.callId});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  Timer? _callTimer;
  int _callDuration = 0;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    _connectToLiveKit();
  }

  Future<void> _connectToLiveKit() async {
    try {
      final call = ref.read(callsProvider);
      final currentUser = ref.read(currentUserProvider);
      
      if (call == null || currentUser == null) return;

      String? token = call.token;
      String? url = call.url;

      // If user doesn't have token (incoming call), get it from backend
      // This happens when user receives call.started event (which doesn't include token)
      if (token == null || url == null) {
        try {
          final apiService = ref.read(apiServiceProvider);
          final tokenResponse = await apiService.getLiveKitToken(
            roomName: call.roomName ?? call.id,
            identity: currentUser.id,
            name: currentUser.name,
          );
          token = tokenResponse['token'] as String;
          // El backend no retorna la URL, usar la constante de Config
          url = tokenResponse['url'] as String? ?? call.url ?? Config.liveKitUrl;
        } catch (e) {
          debugPrint('Error getting LiveKit token: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al obtener token: $e'),
                backgroundColor: AppTheme.danger,
              ),
            );
          }
          return;
        }
      }

      // At this point, token and url should be available
      if (token != null && url != null) {
        final liveKitService = ref.read(liveKitServiceProvider);
        await liveKitService.connect(
          url: url,
          token: token,
        );
        
        if (mounted) {
          ref.read(liveKitConnectionStateProvider.notifier).state = true;
        }
      }
    } catch (e) {
      debugPrint('Error connecting to LiveKit: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al conectar: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration++;
        });
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    final liveKitService = ref.read(liveKitServiceProvider);
    liveKitService.disconnect();
    ref.read(liveKitConnectionStateProvider.notifier).state = false;
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final call = ref.watch(callsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final usersAsync = ref.watch(usersProvider);

    // Si la llamada terminó, regresar automáticamente
    if (call == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && context.canPop()) {
          context.pop();
        } else if (context.mounted) {
          // Si no puede hacer pop, navegar a la pantalla principal
          context.go('/users');
        }
      });
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    User? otherUser;
    if (currentUser != null && usersAsync.hasValue) {
      final otherUserId = call.fromUserId == currentUser.id ? call.toUserId : call.fromUserId;
      otherUser = usersAsync.value!.firstWhere(
        (u) => u.id == otherUserId,
        orElse: () => usersAsync.value!.first,
      );
    }

    final displayName = otherUser?.name ?? 'Unknown';
    final isActive = call.status == 'active';

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
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    color: AppTheme.textPrimary,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock, size: 12, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'CIFRADO DE EXTREMO A EXTREMO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: AppTheme.textPrimary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                  ),
                  child: otherUser != null
                      ? UserAvatar(user: otherUser, size: 200)
                      : CircleAvatar(
                          radius: 100,
                          backgroundColor: AppTheme.primaryPurple,
                          child: Text(
                            displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 80, color: Colors.white),
                          ),
                        ),
                ),
                if (isActive)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 32),

            // Name
            Text(
              displayName,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Duration and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isActive) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(_callDuration),
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ] else
                  const Text(
                    'Calling...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Device Info (optional)
            Text(
              'iPhone de $displayName',
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            ),

            // Audio Waveform (placeholder)
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: 20,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Container(
                      width: 4,
                      height: (index % 2 == 0 ? 16.0 : 8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

            const Spacer(),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                children: [
                  // First Row: 4 buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: 'Silenciar',
                        isActive: _isMuted,
                        onTap: _toggleMicrophone,
                      ),
                      _buildControlButton(
                        icon: Icons.dialpad,
                        label: 'Teclado',
                        onTap: () {},
                      ),
                      _buildControlButton(
                        icon: Icons.volume_up,
                        label: 'Altavoz',
                        isActive: _isSpeakerOn,
                        color: _isSpeakerOn ? AppTheme.primaryBlue : AppTheme.cardDark,
                        onTap: _toggleSpeaker,
                      ),
                      _buildControlButton(
                        icon: Icons.person_add,
                        label: 'Añadir',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Second Row: End Call button
                  _buildControlButton(
                    icon: Icons.call_end,
                    label: '',
                    size: 64,
                    iconSize: 32,
                    color: AppTheme.danger,
                    onTap: () async {
                      // Disconnect from LiveKit first
                      final liveKitService = ref.read(liveKitServiceProvider);
                      await liveKitService.disconnect();
                      
                      // End call in backend
                      await ref.read(callsProvider.notifier).endCall(widget.callId);
                      
                      if (mounted) {
                        context.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double size = 56,
    double iconSize = 24,
    Color? color,
    bool isActive = false,
  }) {
    final buttonColor = color ?? (isActive ? AppTheme.primaryPurple : AppTheme.cardDark);

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _toggleMicrophone() async {
    try {
      final liveKitService = ref.read(liveKitServiceProvider);
      await liveKitService.toggleMicrophone();
      setState(() {
        _isMuted = !_isMuted;
      });
      ref.read(microphoneStateProvider.notifier).state = !_isMuted;
    } catch (e) {
      debugPrint('Error toggling microphone: $e');
    }
  }

  Future<void> _toggleSpeaker() async {
    try {
      final liveKitService = ref.read(liveKitServiceProvider);
      await liveKitService.toggleSpeaker();
      setState(() {
        _isSpeakerOn = !_isSpeakerOn;
      });
      ref.read(speakerStateProvider.notifier).state = _isSpeakerOn;
    } catch (e) {
      debugPrint('Error toggling speaker: $e');
    }
  }
}
