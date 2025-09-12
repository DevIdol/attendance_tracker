import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/constants/constants.dart';
import '../core/theme/theme.dart';
import '../providers/providers.dart';
import '../presentation/routes/routes.dart';
import 'app_config.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).startAuthListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final router = AppRouter.router(ref);

    return MaterialApp.router(
      title: AppConfig.fullAppName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode == ThemeModeOption.light
          ? ThemeMode.light
          : themeMode == ThemeModeOption.dark
              ? ThemeMode.dark
              : ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
