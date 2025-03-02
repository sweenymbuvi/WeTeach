import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/home_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class UserDetailsProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData; // Store user data as a map

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;

  // Dependencies
  final HomeRepository _homeRepository = HomeRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> fetchUserDetails() async {
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
      final userData = await _homeRepository.fetchUserData(accessToken);
      if (userData != null) {
        _userData = userData; // Store the entire user data map
        print("User  Details Fetched Successfully: $_userData");
      } else {
        _errorMessage = "No user data found.";
        print("Error: $_errorMessage");
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("FetchUser  Details Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
