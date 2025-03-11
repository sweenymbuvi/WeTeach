import 'package:dio/dio.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class LiveProfileRepository {
  final Dio _dio = Dio();
  final SecureStorageService _secureStorage = SecureStorageService();
  final String _userDataUrl =
      "https://api.mwalimufinder.com/api/v1/users/teacher/";
  final String _postTeacherProfileUrl =
      "https://api.mwalimufinder.com/api/v1/jobs/teacher/profile/user/";
  final String _makeProfileLiveUrl =
      "https://api.mwalimufinder.com/api/v1/payments/mpesa/profile/make/";
  final String _checkPaymentStatusUrl =
      "https://api.mwalimufinder.com/api/v1/payments/mpesa/confirm/";
  final String _deleteTeacherProfilePostUrl =
      "https://api.mwalimufinder.com/api/v1/jobs/teacher/profile/modify/"; // Base URL for delete

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final response = await _dio.get(
        _userDataUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          final user = data[0];

          // Extract required fields
          final teacherId = user['id'];
          final userId = user['user']['id'];

          String? imageUrl = user['image'] != null
              ? 'https://api.mwalimufinder.com${user['image']}'
              : null;

          String bio = user['bio'] ?? "No bio available";
          String phoneNumber =
              user['phone_number'] ?? "No phone number available";
          String primaryEmail = user['primary_email'] ?? "No email available";
          String countyName = user['county']?['name'] ?? "Unknown County";
          String subCountyName =
              user['sub_county']?['name'] ?? "Unknown Sub-County";

          final List<dynamic> qualifications = user['qualifications'] ?? [];
          final List<Map<String, dynamic>> formattedQualifications =
              qualifications.map((qualification) {
            return {
              'name': qualification['name'] as String,
              'institution_levels':
                  (qualification['institution_level'] as List<dynamic>?)
                          ?.map((level) => level['name'] as String)
                          .toList() ??
                      [],
            };
          }).toList();

          // Extract detailed recent profile post data
          final recentProfilePost = user['recent_profile_post'];
          bool hasActiveProfilePost = user['has_active_profile_post'] ?? false;

          // Create a more detailed profile post object
          Map<String, dynamic>? profilePostDetails;
          if (recentProfilePost != null) {
            profilePostDetails = {
              'id': recentProfilePost['id'],
              'is_active': recentProfilePost['is_active'] ?? false,
              'views': recentProfilePost['views'] ?? 0,
              'creation_time': recentProfilePost['creation_time'],
              'expiry_time': recentProfilePost['expiry_time'],
              'transaction_id': recentProfilePost['payment']?['transaction_id'],
              'payment_status': recentProfilePost['payment']?['payment_status'],
              'payment_method': recentProfilePost['payment']?['payment_method'],
              'amount': recentProfilePost['payment']?['amount'],
              'days_valid': recentProfilePost['payment']?['profile_rate']
                  ?['days'],
            };
          }

          return {
            'teacher_id': teacherId,
            'user_id': userId,
            'full_name': user['full_name'],
            'county': countyName,
            'sub_county': subCountyName,
            'bio': bio,
            'qualifications': formattedQualifications,
            'qualifications_count': qualifications.length,
            'phone_number': phoneNumber,
            'primary_email': primaryEmail,
            'image': imageUrl,
            'has_active_profile_post': hasActiveProfilePost,
            'profile_post':
                profilePostDetails, // Add detailed profile post data
          };
        } else {
          throw Exception("No user data found.");
        }
      } else {
        throw Exception("Failed to fetch user data.");
      }
    } catch (error) {
      print("Fetch User Data Error: $error");
      throw Exception("An error occurred while fetching user data: $error");
    }
  }

  // Post teacher profile
  Future<Map<String, dynamic>?> postTeacherProfile(int teacherId) async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final requestBody = {"teacher": teacherId};

      final response = await _dio.post(
        _postTeacherProfileUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        return {
          "id": data["id"],
          "views": data["views"],
          "is_active": data["is_active"],
          "expiry_time": data["expiry_time"],
          "creation_time": data["creation_time"],
          "last_updated_time": data["last_updated_time"],
          "teacher_profile_id": data["teacher"]["id"],
        };
      } else {
        throw Exception("Failed to create teacher profile.");
      }
    } catch (error) {
      print("Post Teacher Profile Error: $error");
      throw Exception(
          "An error occurred while creating the teacher profile: $error");
    }
  }

  // Make payment to make profile live
  Future<Map<String, dynamic>?> makeProfileLive({
    required String phoneNumber,
    required int teacherProfilePost,
    required int postingRate,
    required int owner,
  }) async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final requestBody = {
        "phone_number": phoneNumber,
        "teacher_profile_post": teacherProfilePost,
        "posting_rate": postingRate,
        "owner": owner,
      };

      final response = await _dio.post(
        _makeProfileLiveUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        return {
          "message": data["message"],
          "payment": {
            "id": data["payment"]["id"],
            "transaction_id": data["payment"]["transaction_id"],
            "checkout_request_id": data["payment"]["checkout_request_id"],
            "payment_status": data["payment"]["payment_status"],
            "payment_method": data["payment"]["payment_method"],
            "amount": data["payment"]["amount"],
            "purpose": data["payment"]["purpose"],
            "checked_out": data["payment"]["checked_out"],
            "creation_time": data["payment"]["creation_time"],
            "last_updated_time": data["payment"]["last_updated_time"],
            "owner": data["payment"]["owner"],
            "teacher_profile_post": data["payment"]["teacher_profile_post"],
          },
        };
      } else {
        throw Exception("Failed to make profile live.");
      }
    } catch (error) {
      print("Make Profile Live Error: $error");
      throw Exception(
          "An error occurred while making the profile live: $error");
    }
  }

  // Check payment status
  Future<Map<String, dynamic>> checkPaymentStatus({
    required int paymentId,
  }) async {
    try {
      // Get the access token
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final response = await _dio.get(
        '$_checkPaymentStatusUrl$paymentId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['payment'];
      } else {
        throw Exception(
            "Failed to check payment status. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error checking payment status: $error");
      throw Exception(
          "An error occurred while checking payment status: $error");
    }
  }

  // Fetch teacher profile post
  Future<Map<String, dynamic>?> fetchTeacherProfilePost() async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final response = await _dio.get(
        _postTeacherProfileUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          final profilePost = data[0]; // Assuming you want the first post

          // Extract required fields
          return {
            'id': profilePost['id'],
            'views': profilePost['views'] ?? 0.0,
            'is_active': profilePost['is_active'] ?? false,
            'expiry_time': profilePost['expiry_time'],
            'creation_time': profilePost['creation_time'],
            'last_updated_time': profilePost['last_updated_time'],
          };
        } else {
          throw Exception("No profile post data found.");
        }
      } else {
        throw Exception("Failed to fetch teacher profile post.");
      }
    } catch (error) {
      print("Fetch Teacher Profile Post Error: $error");
      throw Exception(
          "An error occurred while fetching teacher profile post: $error");
    }
  }

  // Delete teacher profile post
  Future<void> deleteTeacherProfilePost(int postId) async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final requestBody = {
        "teacher": postId
      }; // Request body with teacher profile post ID

      final response = await _dio.delete(
        '$_deleteTeacherProfilePostUrl$postId/', // Append the post ID to the URL
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Deletion was successful, you can return or do nothing
        print("Successfully deleted teacher profile post with ID: $postId");
      } else {
        throw Exception(
            "Failed to delete teacher profile post. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Delete Teacher Profile Post Error: $error");
      throw Exception(
          "An error occurred while deleting the teacher profile post: $error");
    }
  }
}
