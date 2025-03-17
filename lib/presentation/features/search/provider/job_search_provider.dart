import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/home_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class JobSearchProvider with ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  List<Map<String, dynamic>> _allJobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Filter state
  String _searchQuery = '';
  List<String> _selectedLocations = [];
  List<String> _selectedSchoolGenders = [];
  List<String> _selectedSchoolTypes = [];
  List<String> _selectedSubjects = [];

  // Getters
  List<Map<String, dynamic>> get jobs => _filteredJobs;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Filter getters
  String get searchQuery => _searchQuery;
  List<String> get selectedLocations => _selectedLocations;
  List<String> get selectedSchoolGenders => _selectedSchoolGenders;
  List<String> get selectedSchoolTypes => _selectedSchoolTypes;
  List<String> get selectedSubjects => _selectedSubjects;

  // Apply search query
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // Apply filters from bottom sheet
  void applyFilters({
    required List<String> locations,
    required List<String> schoolGenders,
    required List<String> schoolTypes,
    required List<String> subjects,
  }) {
    _selectedLocations = locations;
    _selectedSchoolGenders = schoolGenders;
    _selectedSchoolTypes = schoolTypes;
    _selectedSubjects = subjects;
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    _selectedLocations = [];
    _selectedSchoolGenders = [];
    _selectedSchoolTypes = [];
    _selectedSubjects = [];
    _searchQuery = '';
    _applyFilters();
  }

  Future<void> fetchJobs() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Get the access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch jobs data
      List<Map<String, dynamic>> jobData =
          await _homeRepository.fetchJobData(accessToken);

      // Use the jobData directly since it's already properly formatted in the repository
      _allJobs = jobData.map((job) {
        return {
          'id': job['id'],
          'title': job['title'] ?? 'No Title',
          'county': job['county'] ?? 'Unknown',
          'sub_county': job['sub_county'] ?? 'Unknown',
          'image': job['image'] ?? '',
          'creation_time': job['creation_time'] ?? 'Unknown Date',
          'accommodation': job['accommodation'] ?? 'Unknown',
          'gender': job['gender'] ?? 'Unknown',
          'teacher_requirements': job['teacher_requirements'] ?? [],
          'school_name': job['school_name'] ?? 'Unknown School',
          'school_phone': job['school_phone'] ?? 'Unknown',
          'school_email': job['school_email'] ?? 'Unknown',
          'duties_and_responsibilities':
              job['duties_and_responsibilities'] ?? '',
          'minimum_requirements': job['minimum_requirements'] ?? '',
          'status': job['status'] ?? '',
          'how_to_apply': job['how_to_apply'] ?? '',
          'deadline': job['deadline'] ?? '',
        };
      }).toList();

      // Initialize filtered jobs with all jobs
      _filteredJobs = List.from(_allJobs);

      if (_allJobs.isEmpty) {
        _errorMessage = "No job listings found.";
      }
    } catch (error) {
      _errorMessage = "Failed to load jobs: ${error.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Apply all filters to the jobs list
  void _applyFilters() {
    _filteredJobs = _allJobs.where((job) {
      // Text search filter
      bool matchesSearchQuery = true;
      if (_searchQuery.isNotEmpty) {
        final title = job['title']?.toLowerCase() ?? '';
        final county = job['county']?.toLowerCase() ?? '';
        final subCounty = job['sub_county']?.toLowerCase() ?? '';
        matchesSearchQuery = title.contains(_searchQuery) ||
            county.contains(_searchQuery) ||
            subCounty.contains(_searchQuery);
      }

      // Location filter
      bool matchesLocation = true;
      if (_selectedLocations.isNotEmpty) {
        matchesLocation = _selectedLocations.any((location) {
          final county = job['county']?.toLowerCase() ?? '';
          final subCounty = job['sub_county']?.toLowerCase() ?? '';
          return county.contains(location.toLowerCase()) ||
              subCounty.contains(location.toLowerCase());
        });
      }

      // School gender filter
      bool matchesSchoolGender = true;
      if (_selectedSchoolGenders.isNotEmpty) {
        String jobGender = job['gender']?.toLowerCase() ?? 'unknown';
        matchesSchoolGender = _selectedSchoolGenders.any((gender) {
          return jobGender.contains(gender.toLowerCase());
        });
      }

      // School type filter
      bool matchesSchoolType = true;
      if (_selectedSchoolTypes.isNotEmpty) {
        String jobAccommodation =
            job['accommodation']?.toLowerCase() ?? 'unknown';
        matchesSchoolType = _selectedSchoolTypes.any((type) {
          type = type.toLowerCase();
          if (type == 'day' && jobAccommodation.contains('day')) return true;
          if (type == 'boarding' && jobAccommodation.contains('boarding'))
            return true;
          if (type == 'mixed' &&
              job['gender']?.toLowerCase().contains('mixed') == true)
            return true;
          return false;
        });
      }

      // Subject filter
      bool matchesSubject = true;
      if (_selectedSubjects.isNotEmpty) {
        // Since teacher_requirements is now a list of strings directly from the repository
        List<String> requirements =
            List<String>.from(job['teacher_requirements'] ?? []);

        matchesSubject = _selectedSubjects.any((subject) {
          subject = subject.toLowerCase(); // Ensure lowercase comparison
          return requirements.any((req) => req.toLowerCase() == subject);
        });
      }

      // All conditions must be true for the job to be included
      return matchesSearchQuery &&
          matchesLocation &&
          matchesSchoolGender &&
          matchesSchoolType &&
          matchesSubject;
    }).toList();

    notifyListeners();
  }
}
