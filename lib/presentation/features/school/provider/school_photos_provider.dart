import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/school/school_repo.dart';

class SchoolPhotosProvider extends ChangeNotifier {
  final ViewSchoolRepository _schoolRepository = ViewSchoolRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>>? _schoolPhotos;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>>? get schoolPhotos => _schoolPhotos;

  Future<void> fetchSchoolPhotos(int schoolId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final photos = await _schoolRepository.fetchSchoolPhotos(schoolId);
      if (photos != null) {
        _schoolPhotos = photos;
      } else {
        _errorMessage = "No photos available";
      }
    } catch (e) {
      _errorMessage = "Failed to load school photos";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
