class ErrorHandler {
  static String getErrorMessage(Exception e) {
    if (e is FormatException) {
      return "Invalid response format.";
    } else if (e.toString().contains("SocketException")) {
      return "Network error. Please check your connection.";
    } else {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
