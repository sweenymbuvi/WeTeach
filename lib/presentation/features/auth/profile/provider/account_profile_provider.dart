import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/sign_up_provider.dart';

class AccountProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;
  String? _refreshToken;
  int? _userId; // Variable to store the user ID
  int? _teacherId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to load tokens from SignUpProvider
  Future<void> loadTokens(BuildContext context) async {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _accessToken = signUpProvider.accessToken;
    _refreshToken = signUpProvider.refreshToken;
    _userId = signUpProvider.userId; // Load user ID
    notifyListeners();
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
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return []; // Return an empty list on failure
  }

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

      if (response.statusCode == 200) {
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

  Future<bool> createTeacherProfile({
    required String fullName,
    required String phoneNumber,
    required String bio,
    required int institutionLevel,
    required int experience,
    required int userId, // Added userId as a parameter
  }) async {
    if (_accessToken == null) {
      print("Access token not found. Please sign in again.");
      return false;
    }

    // Prepare the teacher data
    final teacherData = {
      "full_name": fullName,
      "phone_number": phoneNumber,
      "bio": bio,
      "institution_level": institutionLevel,
      "experience": experience,
      "user": userId, // Use the userId parameter
      "is_active": true,
    };

    // Prepare the API request
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

      // Check for success response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('id')) {
          print("Teacher profile created successfully: $responseData");
          // Save the teacher ID for future updates
          _teacherId = responseData['id'];
          return true; // Indicate success
        } else {
          print(
              "Response does not contain expected profile data: $responseData");
        }
      } else {
        // Handle error
        print(
            "Failed to create teacher profile. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (error) {
      print("An error occurred: $error");
    }

    return false; // Return false if the operation was not successful
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
    final url = Uri.parse(
        'https://api.mwalimufinder.com/api/v1/users/teacher/modify/$_teacherId/');
    try {
      var request = http.MultipartRequest('PATCH', url)
        ..headers['Authorization'] = 'Bearer $_accessToken';

      // Add fields to the request
      request.fields['user'] = userId.toString();
      if (fullName != null) request.fields['full_name'] = fullName;
      if (experience != null)
        request.fields['experience'] = experience.toString();
      if (phoneNumber != null) request.fields['phone_number'] = phoneNumber;
      if (primaryEmail != null) request.fields['primary_email'] = primaryEmail;
      if (bio != null) request.fields['bio'] = bio;
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();
      if (formattedAddress != null)
        request.fields['formated_address'] = formattedAddress;
      if (isActive != null) request.fields['is_active'] = isActive.toString();
      if (institutionLevel != null)
        request.fields['institution_level'] = institutionLevel.toString();
      if (county != null) request.fields['county'] = county.toString();
      if (subCounty != null)
        request.fields['sub_county'] = subCounty.toString();

      // Add qualifications as separate fields
      if (qualifications != null) {
        for (int qualification in qualifications) {
          request.fields['qualifications'] = qualification.toString();
        }
      }

      // Add image file to the request
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image));
      }

      final response = await request.send();

      print("Status Code: ${response.statusCode}");

      // Check for success response
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Teacher profile updated successfully.");
        return true; // Indicate success
      } else {
        print(
            "Failed to update teacher profile. Status Code: ${response.statusCode}");
        final responseData = await response.stream.bytesToString();
        print("Response Body: $responseData");
      }
    } catch (error) {
      print("An error occurred: $error");
    }

    return false; // Return false if the operation was not successful
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
