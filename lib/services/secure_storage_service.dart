import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys for storing different values
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _teacherIdKey = 'teacher_id';

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
  }) async {
    await Future.wait([
      storeAccessToken(accessToken),
      storeRefreshToken(refreshToken),
      if (userId != null) storeUserId(userId),
      if (teacherId != null) storeTeacherId(teacherId),
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

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'teacherId': teacherId,
    };
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
}
