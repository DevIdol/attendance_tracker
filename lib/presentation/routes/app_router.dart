import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/constants/constants.dart';
import '../providers/providers.dart';
import '../screens/screens.dart';
import 'route_names.dart';
import 'route_paths.dart';

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: RoutePaths.login,
      redirect: (context, state) {
        final authState = ref.read(authNotifierProvider);

        if (!authState.hasValue) {
          return null;
        }

        final user = authState.valueOrNull;
        final isLoggedIn = user != null;

        final isAuthRoute = state.uri.path == RoutePaths.login ||
            state.uri.path == RoutePaths.register ||
            state.uri.path == RoutePaths.forgotPassword;

        if (!isLoggedIn && !isAuthRoute) {
          return RoutePaths.login;
        }

        if (isLoggedIn && isAuthRoute) {
          return user.role == UserRole.admin
              ? RoutePaths.adminDashboard
              : RoutePaths.userHome;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          builder: (context, state) => const RegistrationScreen(),
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => AdminLayout(child: child),
          routes: [
            GoRoute(
              path: RoutePaths.adminDashboard,
              name: RouteNames.adminDashboard,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const AdminDashboardScreen(),
              ),
            ),
            GoRoute(
              path: RoutePaths.adminUsers,
              name: RouteNames.adminUsers,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const UserListScreen(),
              ),
            ),
            GoRoute(
              path: RoutePaths.adminProfile,
              name: RouteNames.adminProfile,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
              ),
            ),
            GoRoute(
              path: RoutePaths.adminUserHistory,
              name: RouteNames.adminUserHistory,
              builder: (context, state) => UserHistoryScreen(
                userId: state.pathParameters['userId']!,
              ),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) => UserLayout(child: child),
          routes: [
            GoRoute(
              path: RoutePaths.userHome,
              name: RouteNames.userHome,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const HomeScreen(),
              ),
            ),
            GoRoute(
              path: RoutePaths.userHistory,
              name: RouteNames.userHistory,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const HistoryScreen(),
              ),
            ),
            GoRoute(
              path: RoutePaths.userProfile,
              name: RouteNames.userProfile,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Page not found: ${state.uri.path}')),
      ),
    );
  }
}

class AdminLayout extends ConsumerWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = authState.valueOrNull;

    if (user == null || user.role != UserRole.admin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutePaths.login);
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

class UserLayout extends ConsumerWidget {
  final Widget child;

  const UserLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = authState.valueOrNull;

    if (user == null || user.role != UserRole.user) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RoutePaths.login);
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
