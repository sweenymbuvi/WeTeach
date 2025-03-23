import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/profile/profile_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class ChangePasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Dependencies
  final ProfileRepository _profileRepository = ProfileRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get the access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();

      // Print the retrieved access token
      print("Retrieved Access Token: $accessToken");

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        print("Error: $_errorMessage");
        return false;
      }

      // Print request data before making the API call
      print("Attempting Password Change...");
      print("Old Password: $oldPassword");
      print("New Password: $newPassword");
      print("Confirm Password: $confirmPassword");

      // Use the repository to change password
      final success = await _profileRepository.changePassword(
        accessToken: accessToken,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (success) {
        print("Password Change Successful!");
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("ChangePassword Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    print("Password Change Failed.");
    return false;
  }
}
