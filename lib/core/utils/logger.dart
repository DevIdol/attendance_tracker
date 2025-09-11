import 'package:attendance_tracker/config/app_config.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(printEmojis: false),
  filter: _EnvironmentFilter(),
);

class _EnvironmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => AppConfig.enableLogging;
}
