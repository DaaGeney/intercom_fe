import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/users_screen.dart';
import 'ui/screens/devices_screen.dart';
import 'ui/screens/room_screen.dart';
import 'ui/screens/call_screen.dart';
import 'ui/screens/incoming_call_screen.dart';
import 'ui/screens/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const UsersScreen(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UsersScreen(),
        ),
        GoRoute(
          path: '/devices',
          builder: (context, state) => const DevicesScreen(),
        ),
        GoRoute(
          path: '/rooms/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return RoomScreen(roomId: id);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/call/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CallScreen(callId: id);
      },
    ),
    GoRoute(
      path: '/incoming-call/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return IncomingCallScreen(callId: id);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VoiceHub',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
