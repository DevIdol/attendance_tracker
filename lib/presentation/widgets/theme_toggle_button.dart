import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/constants/constants.dart';
import '../providers/providers.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeNotifierProvider);

    return PopupMenuButton<ThemeModeOption>(
      icon: const Icon(Icons.brightness_6),
      onSelected: (ThemeModeOption mode) {
        ref.read(themeNotifierProvider.notifier).toggleTheme(mode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeModeOption>>[
        PopupMenuItem<ThemeModeOption>(
          value: ThemeModeOption.light,
          child: Row(
            children: [
              Icon(
                Icons.wb_sunny,
                color:
                    currentMode == ThemeModeOption.light ? Colors.blue : null,
              ),
              const SizedBox(width: 8),
              const Text('Light'),
            ],
          ),
        ),
        PopupMenuItem<ThemeModeOption>(
          value: ThemeModeOption.dark,
          child: Row(
            children: [
              Icon(
                Icons.nightlight_round,
                color: currentMode == ThemeModeOption.dark ? Colors.blue : null,
              ),
              const SizedBox(width: 8),
              const Text('Dark'),
            ],
          ),
        ),
        PopupMenuItem<ThemeModeOption>(
          value: ThemeModeOption.system,
          child: Row(
            children: [
              Icon(
                Icons.settings_system_daydream,
                color:
                    currentMode == ThemeModeOption.system ? Colors.blue : null,
              ),
              const SizedBox(width: 8),
              const Text('System'),
            ],
          ),
        ),
      ],
    );
  }
}
