import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DebugLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}
