import 'package:attendance_tracker/presentation/screens/common/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../providers/providers.dart';
import '../../routes/routes.dart';

class AdminLayout extends ConsumerWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final authState = ref.watch(authNotifierProvider);
    if (authState.isLoading) {
      return const LoadingScreen();
    }

    final user = authState.valueOrNull;

    if (user == null || user.role != UserRole.admin) {
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
        currentIndex: _getAdminCurrentIndex(currentLocation),
        onTap: (index) => _onAdminNavTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getAdminCurrentIndex(String location) {
    if (location == RoutePaths.adminDashboard) return 0;
    if (location == RoutePaths.adminUsers) return 1;
    if (location == RoutePaths.adminProfile) return 2;
    if (location.contains('user_history')) return 1;
    return 0;
  }

  void _onAdminNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RoutePaths.adminDashboard);
        break;
      case 1:
        context.go(RoutePaths.adminUsers);
        break;
      case 2:
        context.go(RoutePaths.adminProfile);
        break;
    }
  }
}
