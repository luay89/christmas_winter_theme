import 'dart:developer' as developer;

/// Structured logging utility for the application.
/// Replaces print() statements with proper log levels.
/// 
/// Usage:
/// ```dart
/// AppLogger.info('User logged in');
/// AppLogger.error('Failed to load', error: e, stackTrace: stack);
/// ```
class AppLogger {
  static const String _name = 'ChristmasTheme';

  /// Log levels
  static const int _levelDebug = 500;
  static const int _levelInfo = 800;
  static const int _levelWarning = 900;
  static const int _levelError = 1000;

  /// Debug level logging - for development only
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: _levelDebug, error: error, stackTrace: stackTrace);
  }

  /// Info level logging - general information
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: _levelInfo, error: error, stackTrace: stackTrace);
  }

  /// Warning level logging - potential issues
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: _levelWarning, error: error, stackTrace: stackTrace);
  }

  /// Error level logging - errors and exceptions
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, level: _levelError, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String message, {
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: _name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
