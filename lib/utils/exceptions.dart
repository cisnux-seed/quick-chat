class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class DataPickerException implements Exception {
  final String message;

  DataPickerException(this.message);
}
