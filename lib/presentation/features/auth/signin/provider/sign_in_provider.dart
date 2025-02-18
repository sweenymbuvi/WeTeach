import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider with ChangeNotifier {
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

  Future<bool> signIn({required String email, required String password}) async {
    final url = Uri.parse("https://api.mwalimufinder.com/api/v1/auth/token/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Prepare the request body
      final body = jsonEncode({
        "email": email,
        "password": password,
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
        _accessToken = responseData['access'];
        _refreshToken = responseData['refresh'];
        _userId = responseData['user']['id'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        await storeTokens(_accessToken!, _refreshToken!, _userId!);
        return true;
      } else {
        // Handle errors from the server
        if (response.headers["content-type"]?.contains("application/json") ==
            true) {
          final responseData = jsonDecode(response.body);
          _errorMessage = responseData['message'] ??
              "Login failed. Please check your credentials.";
        } else {
          _errorMessage =
              "Server returned an unexpected response: ${response.body}";
        }
      }
    } catch (error) {
      _errorMessage = "An error occurred: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> signInWithPhoneNumber(
      {required String phoneNumber, required String password}) async {
    final url =
        Uri.parse("https://api.mwalimufinder.com/api/v1/users/otp/login/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Prepare the request body
      final body = jsonEncode({
        "phone_number": phoneNumber,
        "password": password,
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
        _accessToken = responseData['access'];
        _refreshToken = responseData['refresh'];
        _userId = responseData['user']['id'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        await storeTokens(_accessToken!, _refreshToken!, _userId!);
        return true;
      } else {
        // Handle errors from the server
        if (response.headers["content-type"]?.contains("application/json") ==
            true) {
          final responseData = jsonDecode(response.body);
          _errorMessage = responseData['message'] ??
              "Login failed. Please check your credentials.";
        } else {
          _errorMessage =
              "Server returned an unexpected response: ${response.body}";
        }
      }
    } catch (error) {
      _errorMessage = "An error occurred: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }
}
