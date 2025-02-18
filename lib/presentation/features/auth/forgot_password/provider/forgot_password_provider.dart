import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to send OTP for password reset
  Future<bool> sendOtpForPasswordReset({required String email}) async {
    return await resendOtp("", email: email);
  }

  // Method to resend OTP
  Future<bool> resendOtp(String s, {required String email}) async {
    final url =
        Uri.parse("https://api.mwalimufinder.com/api/v1/users/otp/resend/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true; // OTP sent successfully
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? "An error occurred";
      }
    } catch (error) {
      _errorMessage = "An error occurred while resending OTP: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false; // Failed to resend OTP
  }
}
