import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double size;

  const UserAvatar({super.key, required this.user, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: AppTheme.primaryPurple.withOpacity(0.3),
          backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null
              ? Text(
                  user.username.isNotEmpty ? user.username.substring(0, 1).toUpperCase() : '?',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.4,
                  ),
                )
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: _getStatusColor(user.status),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return AppTheme.success;
      case 'busy':
        return AppTheme.danger;
      case 'offline':
      default:
        return Colors.grey;
    }
  }
}
