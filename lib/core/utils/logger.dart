import 'package:flutter/foundation.dart';

void logInfo(String message) {
  if (kDebugMode) {
    debugPrint('[INFO] $message');
  }
}

void logError(String message) {
  if (kDebugMode) {
    debugPrint('[ERROR] $message');
  }
}
