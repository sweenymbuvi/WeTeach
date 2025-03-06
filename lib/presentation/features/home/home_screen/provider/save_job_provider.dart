import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/home_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JobSaveProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Set<int> _savedJobIds = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<int> get savedJobIds => _savedJobIds;

  // Dependencies
  final HomeRepository _homeRepository = HomeRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Constructor - Load saved job IDs from storage
  JobSaveProvider() {
    _loadSavedJobs();
  }

  // Check if a job is saved
  bool isJobSaved(int jobId) {
    return _savedJobIds.contains(jobId);
  }

  // Load saved jobs from local storage
  Future<void> _loadSavedJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJobsJson = prefs.getString('saved_jobs');

      if (savedJobsJson != null) {
        final List<dynamic> savedJobs = jsonDecode(savedJobsJson);
        _savedJobIds = savedJobs.map<int>((id) => id as int).toSet();
        notifyListeners();
      }
    } catch (e) {
      print("Error loading saved jobs: $e");
    }
  }

  // Save the list of saved job IDs to local storage
  Future<void> _saveSavedJobsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJobsJson = jsonEncode(_savedJobIds.toList());
      await prefs.setString('saved_jobs', savedJobsJson);
    } catch (e) {
      print("Error saving job IDs to storage: $e");
    }
  }

  // Save a job
  Future<bool> saveJob(int jobId) async {
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
        return false;
      }

      // First get user data to extract the user ID
      Map<String, dynamic>? userData =
          await _homeRepository.fetchUserData(accessToken);

      if (userData == null || !userData.containsKey('user_id')) {
        _errorMessage = "Failed to retrieve user information.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      int userId = userData['user_id'];

      // Save the job with the user ID
      final success = await _homeRepository.saveJob(userId, jobId, accessToken);
      if (success) {
        print("Job saved successfully.");

        // Update the local set of saved job IDs
        _savedJobIds.add(jobId);
        await _saveSavedJobsToStorage();

        notifyListeners();
        return true;
      } else {
        _errorMessage = "Failed to save job.";
        print("Error: $_errorMessage");
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("Save Job Error: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Unsave a job
  Future<bool> unsaveJob(int jobId) async {
    // For now, we'll just update the local state
    // In a real app, you would make an API call to remove the job from saved list

    _savedJobIds.remove(jobId);
    await _saveSavedJobsToStorage();
    notifyListeners();
    return true;
  }

  // Toggle saved status
  Future<bool> toggleSaveJob(int jobId) async {
    if (isJobSaved(jobId)) {
      return await unsaveJob(jobId);
    } else {
      return await saveJob(jobId);
    }
  }
}
