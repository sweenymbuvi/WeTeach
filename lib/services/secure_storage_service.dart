import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys for storing different values
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _teacherIdKey = 'teacher_id';
  static const String _emailKey = 'user_email';
  static const String _otpKey = 'otp_code';
  static const String _processedNotificationIdsKey =
      'processed_notification_ids';

  // Store access token
  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Store refresh token
  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // Store user ID
  Future<void> storeUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  // Store teacher ID
  Future<void> storeTeacherId(int teacherId) async {
    await _storage.write(key: _teacherIdKey, value: teacherId.toString());
  }

  // Store all tokens and IDs at once
  Future<void> storeAllCredentials({
    required String accessToken,
    required String refreshToken,
    int? userId,
    int? teacherId,
    String? userEmail, // Add userEmail parameter
  }) async {
    await Future.wait([
      storeAccessToken(accessToken),
      storeRefreshToken(refreshToken),
      if (userId != null) storeUserId(userId),
      if (teacherId != null) storeTeacherId(teacherId),
      if (userEmail != null) storeEmail(userEmail), // Store userEmail
    ]);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Get user ID
  Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    return value != null ? int.parse(value) : null;
  }

  // Get teacher ID
  Future<int?> getTeacherId() async {
    final value = await _storage.read(key: _teacherIdKey);
    return value != null ? int.parse(value) : null;
  }

  // Get all stored credentials
  Future<Map<String, dynamic>> getAllCredentials() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final userId = await getUserId();
    final teacherId = await getTeacherId();
    final userEmail = await getEmail(); // Retrieve userEmail

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'teacherId': teacherId,
      'userEmail': userEmail, // Include userEmail in the returned map
    };
  }

  // Load tokens and return them
  Future<Map<String, dynamic>> loadTokens() async {
    return await getAllCredentials();
  }

  // Delete all stored credentials
  Future<void> deleteAllCredentials() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _teacherIdKey),
    ]);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    return accessToken != null && userId != null;
  }

  // Store last visited screen
  Future<void> storeLastVisitedScreen(String screenName) async {
    await _storage.write(key: 'last_visited_screen', value: screenName);
  }

// Get last visited screen
  Future<String?> getLastVisitedScreen() async {
    return await _storage.read(key: 'last_visited_screen');
  }

  // Add this method to your SecureStorageService class
  // Store email and last visited screen
  Future<void> storeEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
    await storeLastVisitedScreen(
        'OtpVerificationScreen'); // Ensure screen is saved
  }

// Add a method to retrieve the email if needed
  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<void> storeOtpCode(int otp) async {
    await _storage.write(key: _otpKey, value: otp.toString());
  }

  Future<int?> getOtpCode() async {
    final value = await _storage.read(key: _otpKey);
    return value != null ? int.parse(value) : null;
  }

  Future<void> deleteOtpCode() async {
    await _storage.delete(key: _otpKey);
  }

  // Store processed notification IDs
  Future<void> storeProcessedNotificationIds(String ids) async {
    await _storage.write(key: _processedNotificationIdsKey, value: ids);
  }

  // Get processed notification IDs
  Future<String?> getProcessedNotificationIds() async {
    return await _storage.read(key: _processedNotificationIdsKey);
  }
}
