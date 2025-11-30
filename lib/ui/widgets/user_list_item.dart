import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import 'user_avatar.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserListItem({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: UserAvatar(user: user, size: 50),
      title: Text(
        user.username,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        user.status == 'online' ? 'Active now' : 'Last seen recently',
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            '10:30 AM', // Placeholder time
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (user.status == 'online')
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
