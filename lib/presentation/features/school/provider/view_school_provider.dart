import 'package:flutter/foundation.dart';
import 'package:we_teach/data/repositories/view_job/view_job_repo.dart';

class ViewSchoolProvider extends ChangeNotifier {
  final ViewJobRepository _viewJobRepository = ViewJobRepository();

  Map<String, dynamic>? _jobDetails;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get jobDetails => _jobDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSchoolDetails(int jobId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final jobData = await _viewJobRepository.fetchJobDetails(jobId);
      if (jobData != null) {
        _jobDetails = jobData;
      } else {
        _errorMessage = "Failed to load job details";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
