import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  String? _accessToken;
  String? _refreshToken;
  int? _userId; // Variable to store the user ID

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  int? get userId => _userId; // Getter for user ID

  // Method to store tokens securely
  Future<void> storeTokens(
      String accessToken, String refreshToken, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access', accessToken); // Store as 'access'
    await prefs.setString('refresh', refreshToken); // Store as 'refresh'
    await prefs.setInt('userId', userId); // Store user ID
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access');
    _refreshToken = prefs.getString('refresh');
    _userId = prefs.getInt('userId'); // Load user ID
    _isAuthenticated = _accessToken != null && _userId != null; // Check both
    notifyListeners();
  }

  Future<bool> registerUser({required String email}) async {
    final url =
        Uri.parse("https://api.mwalimufinder.com/api/v1/users/register/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "is_teacher": true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? "An error occurred";
      }
    } catch (error) {
      _errorMessage = "An error occurred: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> registerWithPhoneNumber({required String phoneNumber}) async {
    final url =
        Uri.parse("https://api.mwalimufinder.com/api/v1/users/register/otp/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = jsonEncode({
        "phone_number": phoneNumber,
        "is_teacher": true, // Always set to true
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", // Ensure the server returns JSON
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? "An error occurred";
      }
    } catch (error) {
      _errorMessage = "An error occurred: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> confirmOtp({required int otpCode}) async {
    final url =
        Uri.parse("https://api.mwalimufinder.com/api/v1/users/otp/confirm/");
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
          "otp_code": otpCode,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['message'] == "OTP code confirmed successfully") {
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = "OTP verification failed: ${responseData['message']}";
        }
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = "Failed to confirm OTP: ${responseData['message']}";
      }
    } catch (error) {
      _errorMessage = "An error occurred while confirming OTP: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> setPassword(
      {required int otpCode,
      required String password,
      required String password2}) async {
    final url = Uri.parse(
        "https://api.mwalimufinder.com/api/v1/users/otp/set/password/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = jsonEncode({
        "otp_code": otpCode,
        "password": password,
        "password2": password2,
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        _accessToken = responseData['access']; // Store the access token
        _refreshToken = responseData['refresh']; // Store the refresh token
        _userId = responseData['user']['id']; // Extract and store the user ID

        // Store tokens securely
        await storeTokens(_accessToken!, _refreshToken!, _userId!);

        _errorMessage = responseData['message'] ?? "Password set successfully";
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? "Failed to set password";
      }
    } catch (error) {
      _errorMessage = "An error occurred while setting password: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

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
        return true;
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

    return false;
  }

  // Resend OTP to phone number
  Future<bool> resendOtpPhone(String s, {required String phoneNumber}) async {
    final url = Uri.parse(
        "https://api.mwalimufinder.com/api/v1/users/otp/phone/resend/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = jsonEncode({
        "phone_number": phoneNumber,
      });

      print("Request URL: $url");
      print("Request Body: $body");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", // Ensure the server returns JSON
        },
        body: body,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully resent OTP
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Handle errors from the server
        if (response.headers["content-type"]?.contains("application/json") ==
            true) {
          final responseData = jsonDecode(response.body);
          _errorMessage = responseData['message'] ?? "An error occurred";
        } else {
          _errorMessage =
              "Server returned an unexpected response: ${response.body}";
        }
      }
    } catch (error) {
      // Handle network or unexpected errors
      _errorMessage = "An error occurred while resending OTP to phone: $error";
      print("Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }
}
