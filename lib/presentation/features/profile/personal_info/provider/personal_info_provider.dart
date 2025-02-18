import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/profile_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class PersonalInfoProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  Map<String, String> _counties = {};
  Map<String, String> _subCounties = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  Map<String, String> get counties => _counties;
  Map<String, String> get subCounties => _subCounties;

  // Dependencies
  final ProfileRepository _profileRepository = ProfileRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Fetch personal information
  Future<void> fetchPersonalInfo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userData = await _profileRepository.fetchUserData(accessToken);
      _userData = userData;
      print("Personal Info Fetched Successfully: $_userData");
    } catch (error) {
      _errorMessage = error.toString();
      print("FetchPersonalInfo Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCounties() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        print("Error: $_errorMessage");
        return;
      }

      _counties = (await _profileRepository.fetchCounties(accessToken));
      print("Counties Fetched Successfully: $_counties");
    } catch (error) {
      _errorMessage = error.toString();
      print("FetchCounties Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubCounties(String countyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        print("Error: $_errorMessage");
        return;
      }

      _subCounties =
          (await _profileRepository.fetchSubCounties(accessToken, countyId));
      print("Sub-Counties Fetched Successfully: $_subCounties");
    } catch (error) {
      _errorMessage = error.toString();
      print("FetchSubCounties Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update personal information
  Future<bool> updatePersonalInfo({
    String? fullName,
    int? experience,
    String? phoneNumber,
    String? primaryEmail,
    String? bio,
    double? latitude,
    double? longitude,
    String? formattedAddress,
    bool? isActive,
    int? institutionLevel,
    int? county,
    int? subCounty,
    List<int>? qualifications,
    String? image,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Ensure we have user data with IDs
      if (_userData == null ||
          !_userData!.containsKey('user_id') ||
          !_userData!.containsKey('teacher_id')) {
        _errorMessage = "User  data not loaded. Please refresh and try again.";
        print("Error: $_errorMessage");
        return false;
      }

      final success = await _profileRepository.updateTeacherProfile(
        accessToken: accessToken,
        userId: _userData!['user_id'],
        teacherId: _userData!['teacher_id'],
        fullName: fullName,
        experience: experience,
        phoneNumber: phoneNumber,
        primaryEmail: primaryEmail,
        bio: bio,
        latitude: latitude,
        longitude: longitude,
        formattedAddress: formattedAddress,
        isActive: isActive,
        institutionLevel: institutionLevel,
        county: county,
        subCounty: subCounty,
        qualifications: qualifications,
        image: image,
      );

      if (success) {
        await fetchPersonalInfo();
        print("Profile Updated Successfully");
        return true;
      } else {
        _errorMessage = "Failed to update profile";
        print("Update Profile Error: $_errorMessage");
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("UpdatePersonalInfo Error: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
