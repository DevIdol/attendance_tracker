import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../screens/screens.dart';
import 'route_names.dart';
import 'route_paths.dart';

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: RoutePaths.login,
      redirect: (context, state) async {
        final authState = ref.read(authNotifierProvider);

        if (authState.isLoading) {
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
