import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/devices_controller.dart';
import '../../theme/app_theme.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(devicesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Dispositivos'),
        backgroundColor: AppTheme.backgroundLight,
      ),
      body: devicesAsyncValue.when(
        data: (devices) {
          if (devices.isEmpty) {
            return const Center(child: Text('No devices found', style: TextStyle(color: AppTheme.textSecondary)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: devices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final device = devices[index];
              return Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.devices, color: AppTheme.primaryBlue),
                  ),
                  title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(device.type, style: const TextStyle(color: AppTheme.textSecondary)),
                  trailing: device.userId == null
                      ? ElevatedButton(
                          onPressed: () {
                            // Implement attach logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryBlue,
                            side: const BorderSide(color: AppTheme.primaryBlue),
                          ),
                          child: const Text('Vincular'),
                        )
                      : const Chip(
                          label: Text('Vinculado', style: TextStyle(color: Colors.white)),
                          backgroundColor: AppTheme.success,
                        ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
