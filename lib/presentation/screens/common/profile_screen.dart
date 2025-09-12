import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;

    Future<void> handleSignOut() async {
      try {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (context.mounted) {
          context.showSnackBar('Error signing out: $e', isError: true);
        }
      }
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            user.profileImageUrl != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profileImageUrl!),
                  )
                : const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                user.role == UserRole.admin ? 'Admin' : 'User',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor:
                  user.role == UserRole.admin ? Colors.blue : Colors.green,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Sign Out',
              onPressed: handleSignOut,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
