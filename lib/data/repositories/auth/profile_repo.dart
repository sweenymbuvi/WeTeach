import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ProfileRepository {
  final String baseUrl = "https://api.mwalimufinder.com/api/v1/users/";

  // Fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String accessToken) async {
    final url = Uri.parse('$baseUrl/teacher/');

    try {
      // Print request details
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("Content-Type: application/json");
      print("Accept: application/json");
      print("Authorization: Bearer $accessToken");
      print("}");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // Print response details
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          final user = responseData[0];

          // Extract user and teacher IDs
          final teacherId = user['id']; // This is the teacher profile ID (166)
          final userId = user['user']['id']; // This is the user ID (360)

          // Ensure the image URL is correctly formatted
          String? imageUrl = user['image'] != null
              ? 'https://api.mwalimufinder.com${user['image']}'
              : null;

          // Extract the creation time (joined date)
          String? creationTime = user['creation_time'];
          String joinedDate = _formatJoinedDate(creationTime);

          // Extract institution level data
          final institutionLevel = user['institution_level'];

          // Extract qualifications
          final List<dynamic> qualifications = user['qualifications'];
          final List<String> qualificationNames = qualifications
              .map<String>((qualification) => qualification['name'] as String)
              .toList();

          return {
            'teacher_id': teacherId, // Added teacherId
            'user_id': userId, // Added userId
            'full_name': user['full_name'],
            'county': user['county']['name'],
            'sub_county': user['sub_county']['name'],
            'experience': user['experience'],
            'qualifications': qualificationNames,
            'qualifications_count': qualifications.length,
            'image': imageUrl,
            'joined_date': joinedDate,
            'institution_level_id': institutionLevel['id'],
            'institution_level_name': institutionLevel['name'],
            'primary_email': user['primary_email'],
            'phone_number': user['phone_number'],
          };
        } else {
          throw Exception("No user data found.");
        }
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to fetch user data.");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("An error occurred while fetching user data: $error");
    }
  }

  // Fetch counties
  Future<Map<String, String>> fetchCounties(String accessToken) async {
    final url = Uri.parse('$baseUrl/counties/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        Map<String, String> counties = {};
        for (var county in responseData) {
          counties[county['name']] =
              county['id'].toString(); // Store name and ID
        }
        return counties;
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? "Failed to fetch counties");
      }
    } catch (error) {
      throw Exception("Error fetching counties: $error");
    }
  }

// Fetch sub-counties
  Future<Map<String, String>> fetchSubCounties(
      String accessToken, String countyId) async {
    final url = Uri.parse('$baseUrl/sub-scounties/list/?county__id=$countyId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        Map<String, String> subCounties = {};
        for (var subCounty in responseData) {
          subCounties[subCounty['name']] =
              subCounty['id'].toString(); // Store name and ID
        }
        return subCounties;
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to fetch sub-counties");
      }
    } catch (error) {
      throw Exception("Error fetching sub-counties: $error");
    }
  }

  // Helper function to format the joined date
  String _formatJoinedDate(String? creationTime) {
    if (creationTime == null) return "Unknown";

    // Parse the date string and calculate how long ago the user joined
    DateTime createdDate = DateTime.parse(creationTime);
    Duration difference = DateTime.now().difference(createdDate);

    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} years ago";
    } else if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }

  // Change password
  Future<bool> changePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/user/password/change/');

    // Ensure that the required parameters are not null
    if (accessToken.isEmpty ||
        oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      throw Exception("All fields are required.");
    }

    try {
      final body = jsonEncode({
        "old_password": oldPassword,
        "password": newPassword,
        "password2": confirmPassword,
      });

      // Print request details
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("  Content-Type: application/json");
      print("  Accept: application/json");
      print("  Authorization: Bearer $accessToken");
      print("}");
      print("Request Body: $body");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: body,
      );

      // Print response details
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      // Check for successful response
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true; // Password change was successful
      } else {
        // Handle errors from the server
        if (response.headers["content-type"]?.contains("application/json") ==
            true) {
          final responseData = jsonDecode(response.body);
          throw Exception(responseData['message'] ??
              "Password change failed. Please check your old password.");
        } else {
          throw Exception(
              "Server returned an unexpected response: ${response.body}");
        }
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("An error occurred while changing password: $error");
    }
  }

  // Update teacher profile
  Future<bool> updateTeacherProfile({
    required String accessToken,
    required int userId,
    required int teacherId,
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
    String? image,
  }) async {
    final url = '$baseUrl/teacher/modify/$teacherId/';

    try {
      var dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      // Print request details for consistency with other methods
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("  Authorization: Bearer $accessToken");
      print("}");

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

      // Add image file to the request if provided
      if (image != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(image),
        ));
      }

      // Print request body for debugging
      print("Request Form Data: $formData");

      final response = await dio.patch(url, data: formData);

      // Print response details for consistency with other methods
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Teacher profile updated successfully");
        return true;
      } else {
        print(
            "Failed to update teacher profile. Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");
        throw Exception(response.data['message'] ?? "Failed to update profile");
      }
    } catch (error) {
      print("Error updating teacher profile: $error");
      throw Exception("An error occurred while updating the profile: $error");
    }
  }

  // Fetch subject categories and their subjects
  Future<List<Map<String, dynamic>>> fetchSubjectCategories(
      String accessToken) async {
    final url =
        Uri.parse('https://api.mwalimufinder.com/api/v1/subjects/categories/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken', // Include the access token
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
        return categories; // Return the list of subject categories
      } else {
        throw Exception(
            "Failed to fetch subject categories. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception(
          "An error occurred while fetching subject categories: $error");
    }
  }

  Future<Map<String, dynamic>> createPaymentMethod(
    String accessToken, {
    required String title,
    required String phoneNumber,
  }) async {
    // First fetch the user data to get the user ID
    final userData = await fetchUserData(accessToken);
    if (userData == null) {
      throw Exception("Could not get user data");
    }

    final userId =
        userData['user_id']; // Get the user ID (360) from the fetched data

    final url = Uri.parse(
        'https://api.mwalimufinder.com/api/v1/payments/user/methods/');

    // Create the request body
    final body = jsonEncode({
      'title': title,
      'phone_number': phoneNumber,
      'owner': userId, // Use the user ID from the fetched data
    });

    try {
      // Print request details
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("Content-Type: application/json");
      print("Accept: application/json");
      print("Authorization: Bearer $accessToken");
      print("}");
      print("Request Body: $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      // Print response details
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'id': responseData['id'],
          'title': responseData['title'],
          'phone_number': responseData['phone_number'],
          'creation_time': responseData['creation_time'],
          'last_updated_time': responseData['last_updated_time'],
          'owner': responseData['owner'],
        };
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to create payment method.");
      }
    } catch (error) {
      print("Error creating payment method: $error");
      throw Exception(
          "An error occurred while creating the payment method: $error");
    }
  }

  Future<List<Map<String, dynamic>>> fetchPaymentMethods(
      String accessToken) async {
    final url = Uri.parse(
        'https://api.mwalimufinder.com/api/v1/payments/user/methods/');

    try {
      // Print request details
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("Content-Type: application/json");
      print("Accept: application/json");
      print("Authorization: Bearer $accessToken");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // Print response details
      print("Status Code: \${response.statusCode}");
      print("Response Headers: \${response.headers}");
      print("Response Body: \${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((method) => {
                  'id': method['id'],
                  'title': method['title'],
                  'phone_number': method['phone_number'],
                  'creation_time': method['creation_time'],
                  'last_updated_time': method['last_updated_time'],
                  'owner': method['owner'],
                })
            .toList();
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to fetch payment methods.");
      }
    } catch (error) {
      print("Error fetching payment methods: $error");
      throw Exception(
          "An error occurred while fetching payment methods: $error");
    }
  }

  // Update payment method
  Future<bool> updatePaymentMethod(
    String accessToken, {
    required String paymentMethodId,
    String? title,
    String? phoneNumber,
  }) async {
    final userData = await fetchUserData(accessToken);
    if (userData == null) {
      throw Exception("Could not get user data");
    }

    final userId = userData['user_id'];

    final url = Uri.parse(
        'https://api.mwalimufinder.com/api/v1/payments/user/methods/modify/$paymentMethodId/');

    final body = jsonEncode({
      if (title != null) 'title': title,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      'owner': userId,
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to update payment method.");
      }
    } catch (error) {
      throw Exception(
          "An error occurred while updating the payment method: $error");
    }
  }

  // Delete payment method
  Future<bool> deletePaymentMethod(
      String accessToken, String paymentMethodId) async {
    final url = Uri.parse(
        'https://api.mwalimufinder.com/api/v1/payments/user/methods/modify/$paymentMethodId/');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to delete payment method.");
      }
    } catch (error) {
      throw Exception(
          "An error occurred while deleting the payment method: $error");
    }
  }
}
