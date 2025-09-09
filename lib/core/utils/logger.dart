import 'package:logger/logger.dart';

import '../../config/config.dart';

final logger = Logger(
  printer: PrettyPrinter(printEmojis: false),
  filter: _EnvironmentFilter(),
);

class _EnvironmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return AppConfig.enableLogging.toString() == 'true';
  }
}
