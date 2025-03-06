import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:we_teach/data/repositories/auth/my_jobs_repo.dart';
import 'dart:async';

class MyJobsProvider with ChangeNotifier {
  final MyJobsRepository _myJobsRepository = MyJobsRepository();

  List<Map<String, dynamic>> _savedJobs = [];
  List<Map<String, dynamic>> _viewedJobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get savedJobs => _savedJobs;
  List<Map<String, dynamic>> get viewedJobs => _viewedJobs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSavedJobs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> jobs =
          await _myJobsRepository.fetchSavedJobs().timeout(
                const Duration(seconds: 15),
                onTimeout: () => throw TimeoutException('Connection timed out'),
              );

      _savedJobs = jobs.map((job) {
        return {
          "id": job["job"]["id"],
          "saved_time": timeago.format(DateTime.parse(job["creation_time"])),
          "job_title": job["job"]["title"],
          "school_image": job["job"]["school"]["image"] != null
              ? "https://api.mwalimufinder.com${job["job"]["school"]["image"]}"
              : null, // ✅ Ensures full URL
          "sub_county": job["job"]["school"]["sub_county"]["name"],
          "county": job["job"]["school"]["sub_county"]["county"]["name"],
        };
      }).toList();
    } catch (error) {
      if (error is TimeoutException) {
        _errorMessage =
            'Connection timed out. Please check your internet connection.';
      } else if (error.toString().contains('connection closed')) {
        _errorMessage = 'Network error. Please try again later.';
      } else {
        _errorMessage = error.toString();
      }
      print('Fetch Saved Jobs Error: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchViewedJobs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Map<String, dynamic>> jobs =
          await _myJobsRepository.fetchViewedJobs().timeout(
                const Duration(seconds: 15),
                onTimeout: () => throw TimeoutException('Connection timed out'),
              );

      // Base URL for media files
      const String baseUrl = "https://api.mwalimufinder.com";

      // Map and format job data properly
      _viewedJobs = jobs.map((job) {
        return {
          "id": job["id"],
          "viewed_time": timeago.format(DateTime.parse(job["creation_time"])),
          "job_title": job["title"],
          "school_image": job["school"]["image"] != null
              ? "$baseUrl${job["school"]["image"]}" // Ensure full URL
              : "assets/images/app_icon.png", // Fallback image
          "sub_county": job["school"]["sub_county"]["name"],
          "county": job["school"]["sub_county"]["county"]["name"],
        };
      }).toList();
    } catch (error) {
      if (error is TimeoutException) {
        _errorMessage =
            'Connection timed out. Please check your internet connection.';
      } else if (error.toString().contains('connection closed')) {
        _errorMessage = 'Network error. Please try again later.';
      } else {
        _errorMessage = error.toString();
      }
      print('Fetch Viewed Jobs Error: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method to add a job immediately to saved jobs list
  void addLocalSavedJob(Map<String, dynamic> jobData) {
    // Format job data to match the structure used in savedJobs
    final Map<String, dynamic> formattedJob = {
      "id": jobData["id"],
      "saved_time": timeago.format(DateTime.now()),
      "job_title": jobData["title"],
      "school_image": jobData["school"]["image"] != null
          ? "https://api.mwalimufinder.com${jobData["school"]["image"]}"
          : null,
      "sub_county": jobData["school"]["sub_county"]["name"],
      "county": jobData["school"]["sub_county"]["county"]["name"],
    };

    // Add job to the start of the list (most recent)
    _savedJobs.insert(0, formattedJob);
    notifyListeners();
  }

  // ✅ Added delete saved job functionality
  Future<void> deleteSavedJob(int jobId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Remove the job from the local list FIRST
      _savedJobs.removeWhere((job) => job['id'] == jobId);

      // Call the repository to delete the job
      await _myJobsRepository.deleteSavedJob(jobId);

      // Optional: If you want to ensure the list is up to date
      // But do this only if you're certain the backend might have changed
      // await fetchSavedJobs();
    } catch (error) {
      // If deletion fails, add the job back to the list
      print("Delete Saved Job Error: $error");

      // Optionally, re-add the job to the list if deletion fails
      // You might want to keep the original job object if possible
      // _savedJobs.add(jobToBeDeleted);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
