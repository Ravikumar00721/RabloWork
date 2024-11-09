// app_exception.dart
class AppException implements Exception {
  final String message;
  final String prefix;

  AppException([this.message = "Something went wrong", this.prefix = "Error: "]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

// Define specific exceptions
class NetworkException extends AppException {
  NetworkException([String message = "No Internet connection."]) 
      : super(message, "Network Error: ");
}

class TimeoutException extends AppException {
  TimeoutException([String message = "The connection has timed out."]) 
      : super(message, "Timeout Error: ");
}

class InvalidResponseException extends AppException {
  InvalidResponseException([String message = "Invalid response from the server."]) 
      : super(message, "Invalid Response: ");
}

class UnknownException extends AppException {
  UnknownException([String message = "Unknown error occurred."]) 
      : super(message, "Unknown Error: ");
}
