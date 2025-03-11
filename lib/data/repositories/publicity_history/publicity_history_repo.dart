import 'package:dio/dio.dart';
import 'package:we_teach/constants/app_urls.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class PublicityHistoryRepository {
  final Dio _dio = Dio();
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final response = await _dio.get(
        AppUrls.getTeacherDetails,
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

          bool hasActiveProfilePost = user['has_active_profile_post'] ?? false;
          final recentProfilePost = user['recent_profile_post'];

          Map<String, dynamic>? profilePostDetails;
          List<Map<String, dynamic>> publicityHistory = [];

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
              'charges': recentProfilePost['payment']?['profile_rate']
                  ?['charges'],
            };

            // Create a publicity history item from the recent profile post
            bool isActive = recentProfilePost['is_active'] ?? false;
            int days =
                recentProfilePost['payment']?['profile_rate']?['days'] ?? 0;
            double price =
                (recentProfilePost['payment']?['amount'] ?? 0).toDouble();

            // Convert views to int
            int impressions =
                (recentProfilePost['views'] ?? 0.0).toInt(); // Convert to int
            String expiryDate = "";

            if (recentProfilePost['expiry_time'] != null) {
              DateTime expiry =
                  DateTime.parse(recentProfilePost['expiry_time']);
              expiryDate = "${expiry.day}/${expiry.month}/${expiry.year}";
            }

            publicityHistory.add({
              'status': isActive ? "active" : "expired",
              'days': days,
              'price': price,
              'impressions': impressions,
              'expiryDate': expiryDate,
            });
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
            'profile_post': profilePostDetails,
            'publicityHistory': publicityHistory, // Add this field
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
}
