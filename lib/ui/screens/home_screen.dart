import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/users');
        break;
      case 1:
        // context.go('/rooms'); // Assuming rooms list is separate or part of users
        // For now, let's map it to devices or keep it as placeholder
        context.go('/devices');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for large screen
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) => _onItemTapped(index, context),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble),
                  label: Text('Chats'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.devices),
                  label: Text('Devices'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          if (isDesktop)
            const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  activeIcon: Icon(Icons.chat_bubble),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.devices),
                  label: 'Devices',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppTheme.primaryBlue,
              onTap: (index) => _onItemTapped(index, context),
            )
          : null,
    );
  }
}
