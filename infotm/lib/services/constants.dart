abstract class Constants {
  static final alNumRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  static final nameRegExp = RegExp(r'^[a-zA-Z][a-zA-Z\-]*[a-zA-Z]$');
  static const timeoutDuration = Duration(seconds: 7);
  static const sqlTimeoutDuration = Duration(seconds: 10);
  static const String sqlTimeoutMessage = 'SQL connection timed out';
}
