import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/publicity_history/publicity_history_repo.dart';

class PublicityHistoryProvider extends ChangeNotifier {
  final PublicityHistoryRepository _repository = PublicityHistoryRepository();

  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  bool _shouldShowProfilePopup = false;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;
  String? get errorMessage => _errorMessage;
  bool get shouldShowProfilePopup => _shouldShowProfilePopup;

  List<dynamic> get publicityHistory => _userData?["publicityHistory"] ?? [];

  Future<void> fetchPublicityHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.fetchUserData();
      _userData = data;

      // Check if recentProfilePost is null
      _shouldShowProfilePopup = data?['profile_post'] == null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetProfilePopupFlag() {
    _shouldShowProfilePopup = false;
    notifyListeners();
  }
}
