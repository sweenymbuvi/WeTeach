import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/payment_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class JobPaymentProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _paymentStatus; // Payment status (Paid/Failed)
  List<Map<String, dynamic>> _paymentMethods = [];
  Map<String, dynamic>? _paymentResponse;
  Map<String, dynamic>? _userData;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get paymentStatus => _paymentStatus;
  List<Map<String, dynamic>> get paymentMethods => _paymentMethods;
  Map<String, dynamic>? get paymentResponse => _paymentResponse;
  Map<String, dynamic>? get userData => _userData;

  // Dependencies
  final PaymentRepository _paymentRepository = PaymentRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Fetch user details
  Future<void> fetchUserDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please login again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userData = await _paymentRepository.fetchUserData(accessToken);
      if (userData != null) {
        _userData = userData;
        print("User Details Fetched Successfully: $_userData");
      } else {
        _errorMessage = "No user data found.";
      }
    } catch (error) {
      _errorMessage = "Error fetching user details: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  // Make a payment using MPESA
  Future<void> makePayment({
    required String phoneNumber,
    required int jobId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _paymentResponse = null;
    _paymentStatus = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please log in again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Ensure user details are fetched
      if (_userData == null || !_userData!.containsKey('user_id')) {
        await fetchUserDetails(); // Fetch user details if not already fetched
      }

      if (_userData == null || !_userData!.containsKey('user_id')) {
        _errorMessage = "User details unavailable. Please try again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final int ownerId = _userData!['user_id'];

      final paymentData = await _paymentRepository.makePayment(
        accessToken: accessToken,
        phoneNumber: phoneNumber,
        jobId: jobId,
      );

      _paymentResponse = paymentData;
      final int paymentId = paymentData['payment']['id'];

      await checkPaymentStatus(accessToken: accessToken, paymentId: paymentId);
    } catch (error) {
      _errorMessage = "Error making payment: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check Payment Status
  Future<void> checkPaymentStatus({
    required String accessToken,
    required int paymentId,
  }) async {
    try {
      final paymentStatusResponse = await _paymentRepository.checkPaymentStatus(
        accessToken: accessToken,
        paymentId: paymentId,
      );

      _paymentStatus = paymentStatusResponse['payment_status'];

      if (_paymentStatus == 'Paid') {
        _paymentStatus = "Payment Successful ✅";
      } else {
        _paymentStatus = "Payment Failed ❌";
      }
    } catch (error) {
      _errorMessage = "Error checking payment status: $error";
    } finally {
      notifyListeners();
    }
  }
}
