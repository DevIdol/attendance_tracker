import 'package:attendance_tracker/presentation/screens/common/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../providers/providers.dart';
import '../../routes/routes.dart';

class UserLayout extends ConsumerWidget {
  final Widget child;

  const UserLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading) {
      return const LoadingScreen();
    }

    final user = authState.valueOrNull;

    if (user == null || user.role != UserRole.user) {
      Future.microtask(() {
        if (context.mounted) {
          context.go(RoutePaths.login);
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getUserCurrentIndex(currentLocation),
        onTap: (index) => _onUserNavTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getUserCurrentIndex(String location) {
    if (location == RoutePaths.userHome) return 0;
    if (location == RoutePaths.userHistory) return 1;
    if (location == RoutePaths.userProfile) return 2;
    return 0;
  }

  void _onUserNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RoutePaths.userHome);
        break;
      case 1:
        context.go(RoutePaths.userHistory);
        break;
      case 2:
        context.go(RoutePaths.userProfile);
        break;
    }
  }
}
