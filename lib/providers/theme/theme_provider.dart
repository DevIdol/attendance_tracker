import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/utils.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  static const _themeKey = 'theme_mode';

  @override
  ThemeModeOption build() {
    final storage = GetStorage();
    final storedTheme = storage.read<String>(_themeKey);
    final initialTheme = _parseThemeMode(storedTheme) ?? ThemeModeOption.system;
    logger.i('Initialized theme from storage: $initialTheme');
    return initialTheme;
  }

  void toggleTheme(ThemeModeOption mode) {
    logger.i('Changing theme to: $mode');
    state = mode;
    final storage = GetStorage();
    storage.write(_themeKey, mode.toString().split('.').last);
    logger.i('Theme saved to storage: $mode');
  }

  ThemeModeOption? _parseThemeMode(String? storedTheme) {
    if (storedTheme == null) return null;
    try {
      return ThemeModeOption.values.firstWhere(
        (e) => e.toString().split('.').last == storedTheme,
      );
    } catch (e) {
      logger.e('Error parsing stored theme: $e');
      return null;
    }
  }
}
