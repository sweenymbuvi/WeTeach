import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/payment_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class LiveProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _paymentMethods = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get paymentMethods => _paymentMethods;

  // Dependencies
  final PaymentRepository _paymentRepository = PaymentRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Fetch payment methods
  Future<void> fetchPaymentMethods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please log in again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final methods = await _paymentRepository.fetchPaymentMethods(accessToken);
      _paymentMethods = methods;
    } catch (error) {
      _errorMessage = "Error fetching payment methods: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
