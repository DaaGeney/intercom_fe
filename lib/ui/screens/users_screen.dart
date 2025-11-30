import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/users_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/user_list_item.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Chats'),
        elevation: 0,
        backgroundColor: AppTheme.backgroundLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=68'), // Placeholder
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: usersAsyncValue.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No active chats.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      child: UserListItem(
                        user: user,
                        onTap: () {
                          // Start a call for demo purposes, or go to chat
                          context.push('/call/demo_call_${user.id}');
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Logic to create new chat/group
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo chat'),
      ),
    );
  }
}
