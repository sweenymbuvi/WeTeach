import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/profile/profile_repo.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class PaymentProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _paymentMethods = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get paymentMethods => _paymentMethods;

  // Dependencies
  final ProfileRepository _profileRepository = ProfileRepository();
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
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch payment methods using ProfileRepository
      final methods = await _profileRepository.fetchPaymentMethods(accessToken);
      _paymentMethods = methods;
      print("Fetched Payment Methods: $_paymentMethods");
    } catch (error) {
      _errorMessage = "Error fetching payment methods: $error";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create payment method
  Future<Map<String, dynamic>?> createPaymentMethod(
      String title, String phoneNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please log in again.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return null; // Return null in case of authentication failure
      }

      // Call the createPaymentMethod function from ProfileRepository
      final paymentMethod = await _profileRepository.createPaymentMethod(
        accessToken,
        title: title,
        phoneNumber: phoneNumber,
      );

      _paymentMethods.add(paymentMethod);
      print("Payment Method Created Successfully: $paymentMethod");

      return paymentMethod; // Return the created payment method
    } catch (error) {
      _errorMessage = "Error creating payment method: $error";
      print(_errorMessage);
      return null; // Return null in case of an error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update payment method
  Future<void> updatePaymentMethod(
    String paymentMethodId,
    String completePhoneNumber, {
    String? title,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please log in again.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final success = await _profileRepository.updatePaymentMethod(
        accessToken,
        paymentMethodId: paymentMethodId,
        title: title,
        phoneNumber: phoneNumber,
      );

      if (success) {
        // Refresh payment methods after update
        await fetchPaymentMethods();
        print("Payment Method Updated Successfully");
      }
    } catch (error) {
      _errorMessage = "Error updating payment method: $error";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete payment method
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken == null) {
        _errorMessage = "Not authenticated. Please log in again.";
        print("Error: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return;
      }

      await _profileRepository.deletePaymentMethod(
          accessToken, paymentMethodId);
      _paymentMethods.removeWhere((method) => method['id'] == paymentMethodId);
      print("Payment Method Deleted Successfully");
    } catch (error) {
      _errorMessage = "Error deleting payment method: $error";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
