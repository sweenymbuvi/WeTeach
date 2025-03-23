import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/home/home_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class JobDetailsProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>>? _jobsData; // Store jobs data as a list of maps

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>>? get jobsData => _jobsData;

  // Dependencies
  final HomeRepository _homeRepository = HomeRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> fetchJobDetails() async {
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

      // Fetch jobs data
      final jobsData = await _homeRepository.fetchJobData(accessToken);
      if (jobsData.isNotEmpty) {
        _jobsData = jobsData; // Store the entire jobs data list
        print("Job Details Fetched Successfully: ${_jobsData!.length} jobs");
      } else {
        _errorMessage = "No job listings found.";
        print("Error: $_errorMessage");
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("FetchJob Details Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
