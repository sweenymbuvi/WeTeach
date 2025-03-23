import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/profile/profile_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class UserProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;

  // Dependencies
  final ProfileRepository _profileRepository = ProfileRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get the access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch user data
      final userData = await _profileRepository.fetchUserData(accessToken);
      _userData = userData;
      print("User Data Fetched Successfully: $_userData");
    } catch (error) {
      _errorMessage = error.toString();
      print("FetchUserProfile Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
