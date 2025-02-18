import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; //flutter secure storage
import 'package:dio/dio.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  String? _accessToken;
  String? _refreshToken;
  int? _userId; // Variable to store the user ID
  int? _teacherId;
  String? _userEmail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  int? get userId => _userId; // Getter for user ID
  int? get teacherId => _teacherId;
  String? get userEmail => _userEmail;

  // Method to store tokens securely
  final _secureStorage = SecureStorageService();

  Future<void> storeTokens(
    String accessToken,
    String refreshToken,
    int? userId, // Make userId nullable
  ) async {
    await _secureStorage.storeAllCredentials(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId, // Pass userId (can be null)
    );
  }

  Future<void> loadTokens() async {
    final credentials = await _secureStorage.getAllCredentials();
    _accessToken = credentials['accessToken'];
    _refreshToken = credentials['refreshToken'];
    _userId = credentials['userId'];
    _isAuthenticated = await _secureStorage.isAuthenticated();
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
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isAuthenticated = true;
        _userEmail = email; // Store the email when registration is successful
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final responseData = jsonDecode(response.body);

        if (responseData['email'] != null &&
            responseData['email'][0] == "This field must be unique.") {
          _errorMessage =
              "This email is already registered. Please use a different one.";
        } else {
          _errorMessage = responseData['message'] ?? "An error occurred";
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

  Future<bool> registerWithPhoneNumber({
    required String phoneNumber,
  }) async {
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
        // Successfully registered
        _isAuthenticated = true;
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
      _errorMessage = "An error occurred: $error";
      print("Error: $error");
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

  Future<bool> setPassword({
    required int otpCode,
    required String password,
    required String password2,
  }) async {
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
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

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

      print("Request URL: $url");
      print("Request Body: $body");

      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        _accessToken = responseData['access'];
        _refreshToken = responseData['refresh'];
        int? userId = responseData[
            'user_id']; // Assuming the user ID is returned in the response
        _isAuthenticated = true;
        _isLoading = false;

        // Store tokens in secure storage (with userId)
        await storeTokens(
          _accessToken!,
          _refreshToken!,
          userId, // Pass userId (can be null)
        );

        notifyListeners();
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
      // Handle network or unexpected errors
      _errorMessage = "An error occurred: $error";
      print("SignIn Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> signInWithPhoneNumber({
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse(
        "https://api.mwalimufinder.com/api/v1/users/otp/login/"); // Update the endpoint
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Prepare the request body
      final body = jsonEncode({
        "phone_number": phoneNumber,
        "password": password,
      });

      print("Request URL: $url");
      print("Request Body: $body");

      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        _accessToken = responseData['access'];
        _refreshToken = responseData['refresh'];
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
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
      // Handle network or unexpected errors
      _errorMessage = "An error occurred: $error";
      print("SignInWithPhoneNumber Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  Future<bool> sendOtpForPasswordReset({required String email}) async {
    // Use the resendOtp method to send the OTP for password reset
    return await resendOtp("", email: email);
  }

  Future<List<String>> fetchCounties() async {
    final url =
        Uri.parse("https://api.mwalimufinder.com/api/v1/users/counties/");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $_accessToken", // Include the access token
          "Accept": "application/json",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        // Extract county names directly
        List<String> countyNames = responseData
            .map((countyJson) => countyJson['name'] as String)
            .toList();
        _isLoading = false;
        notifyListeners();
        return countyNames; // Return the list of county names
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? "Failed to fetch counties";
      }
    } catch (error) {
      _errorMessage = "An error occurred while fetching counties: $error";
      print("Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return []; // Return an empty list on failure
  }

  Future<List<String>> fetchSubCounties(String countyId) async {
    final url = Uri.parse(
        "https://api.mwalimufinder.com/api/v1/users/sub-scounties/list/?county__id=$countyId");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $_accessToken", // Include the access token
          "Accept": "application/json",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        // Extract sub-county names directly
        List<String> subCountyNames = responseData
            .map((subCountyJson) => subCountyJson['name'] as String)
            .toList();
        _isLoading = false;
        notifyListeners();
        return subCountyNames; // Return the list of sub-county names
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage =
            responseData['message'] ?? "Failed to fetch sub-counties";
      }
    } catch (error) {
      _errorMessage = "An error occurred while fetching sub-counties: $error";
      print("Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return []; // Return an empty list on failure
  }

  Future<bool> createTeacherProfile({
    required String fullName,
    required String phoneNumber,
    required String bio,
    required int institutionLevel,
    required int experience,
    required int userId,
  }) async {
    if (_accessToken == null) {
      print("Access token not found. Please sign in again.");
      return false;
    }

    if (_userEmail == null) {
      print("User email not found. Please register first.");
      return false;
    }

    final teacherData = {
      "full_name": fullName,
      "phone_number": phoneNumber,
      "bio": bio,
      "institution_level": institutionLevel,
      "experience": experience,
      "user": userId,
      "is_active": true,
      "primary_email": _userEmail, // Use the stored email here
    };

    final url =
        Uri.parse('https://api.mwalimufinder.com/api/v1/users/teacher/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: jsonEncode(teacherData),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('id')) {
          print("Teacher profile created successfully: $responseData");
          _teacherId = responseData['id'];
          return true;
        } else {
          print(
              "Response does not contain expected profile data: $responseData");
        }
      } else {
        print(
            "Failed to create teacher profile. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (error) {
      print("An error occurred: $error");
    }
    return false;
  }

  Future<bool> updateTeacherProfile({
    required int userId,
    String? fullName,
    int? experience,
    String? phoneNumber,
    String? primaryEmail,
    String? bio,
    double? latitude,
    double? longitude,
    String? formattedAddress,
    bool? isActive,
    int? institutionLevel,
    int? county,
    int? subCounty,
    List<int>? qualifications,
    String? image, // Image path
  }) async {
    // Ensure the teacher ID and access token are available
    if (_teacherId == null || _accessToken == null) {
      print("Teacher ID or access token not found. Please sign in again.");
      return false;
    }

    // Prepare the API request
    final url =
        'https://api.mwalimufinder.com/api/v1/users/teacher/modify/$_teacherId/';
    try {
      var dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $_accessToken';

      var formData = FormData.fromMap({
        'user': userId.toString(),
        if (fullName != null) 'full_name': fullName,
        if (experience != null) 'experience': experience.toString(),
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (primaryEmail != null) 'primary_email': primaryEmail,
        if (bio != null) 'bio': bio,
        if (latitude != null) 'latitude': latitude.toString(),
        if (longitude != null) 'longitude': longitude.toString(),
        if (formattedAddress != null) 'formated_address': formattedAddress,
        if (isActive != null) 'is_active': isActive.toString(),
        if (institutionLevel != null)
          'institution_level': institutionLevel.toString(),
        if (county != null) 'county': county.toString(),
        if (subCounty != null) 'sub_county': subCounty.toString(),
        if (qualifications != null)
          'qualifications': qualifications.map((q) => q.toString()).toList(),
      });

      // Add image file to the request
      if (image != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(image),
        ));
      }

      final response = await dio.patch(url, data: formData);

      print("Status Code: ${response.statusCode}");

      // Check for success response
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Teacher profile updated successfully.");
        return true; // Indicate success
      } else {
        print(
            "Failed to update teacher profile. Status Code: ${response.statusCode}");
        print("Response Body: ${response.data}");
      }
    } catch (error) {
      print("An error occurred: $error");
    }

    return false; // Return false if the operation was not successful
  }

  // Method to fetch subjects
  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    final url = Uri.parse('https://api.mwalimufinder.com/api/v1/subjects/');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken', // Include the access token
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        // Map the response to a list of subjects
        List<Map<String, dynamic>> subjects = responseData.map((subject) {
          return {
            'id': subject['id'],
            'name': subject['name'],
          };
        }).toList();
        _isLoading = false;
        notifyListeners();
        return subjects; // Return the list of subjects
      } else {
        _errorMessage =
            "Failed to fetch subjects. Status Code: ${response.statusCode}";
      }
    } catch (error) {
      _errorMessage = "An error occurred while fetching subjects: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return []; // Return an empty list on failure
  }

  // Method to fetch subject categories and their subjects
  Future<List<Map<String, dynamic>>> fetchSubjectCategories() async {
    final url =
        Uri.parse('https://api.mwalimufinder.com/api/v1/subjects/categories/');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken', // Include the access token
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        // Map the response to a list of subject categories
        List<Map<String, dynamic>> categories = responseData.map((category) {
          return {
            'id': category['id'],
            'name': category['name'],
            'subjects': category['subjects'].map((subject) {
              return {
                'id': subject['id'],
                'name': subject['name'],
              };
            }).toList(),
          };
        }).toList();
        _isLoading = false;
        notifyListeners();
        return categories; // Return the list of subject categories
      } else {
        _errorMessage =
            "Failed to fetch subject categories. Status Code: ${response.statusCode}";
      }
    } catch (error) {
      _errorMessage =
          "An error occurred while fetching subject categories: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return []; // Return an empty list on failure
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final url =
        Uri.parse('https://api.mwalimufinder.com/api/v1/users/teacher/');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken', // Include the access token
          'Content-Type': 'application/json',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          final user = responseData[0];

          // Ensure the image URL is correctly formatted
          String? imageUrl = user['image'] != null
              ? 'https://api.mwalimufinder.com${user['image']}'
              : null;

          return {
            'full_name': user['full_name'],
            'county': user['county']['name'],
            'sub_county': user['sub_county']['name'],
            'experience': user['experience'],
            'qualifications': user['qualifications'].length,
            'image': imageUrl, // Correctly formatted full image URL
          };
        } else {
          _errorMessage = "No user data found.";
        }
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'] ?? "Failed to fetch user data.";
      }
    } catch (error) {
      _errorMessage = "An error occurred while fetching user data: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }
}
