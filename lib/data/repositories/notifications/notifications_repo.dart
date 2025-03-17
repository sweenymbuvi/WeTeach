import 'package:dio/dio.dart';
import 'package:we_teach/constants/app_urls.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class NotificationsRepository {
  final Dio _dio = Dio();
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Fetch Notifications
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final response = await _dio.get(
        AppUrls.getNotifications,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        return data.map((notification) {
          final owner = notification['owner'] ?? {};
          final ownerDetails = {
            'id': owner['id'],
            'email': owner['email'] ?? "No email",
            'phone_number': owner['phone_number'] ?? "No phone number",
          };

          final qualifications = (notification['qualifications'] as List?)
                  ?.map((qualification) => {
                        'id': qualification['id'],
                        'name': qualification['name'],
                        'institution_levels':
                            (qualification['institution_level'] as List?)
                                    ?.map((level) => level['name'])
                                    .toList() ??
                                [],
                      })
                  .toList() ??
              [];

          return {
            'id': notification['id'],
            'title': notification['title'] ?? "No title",
            'message': notification['message'] ?? "No message",
            'is_viewed': notification['is_viewed'] ?? false,
            'creation_time': notification['creation_time'] ?? "",
            'last_updated_time': notification['last_updated_time'] ?? "",
            'owner': ownerDetails,
            'job': notification['job'],
            'qualifications': qualifications,
          };
        }).toList();
      } else {
        throw Exception("Failed to fetch notifications.");
      }
    } catch (error) {
      print("Fetch Notifications Error: $error");
      throw Exception("An error occurred while fetching notifications: $error");
    }
  }

  /// Update Notification
  Future<List<Map<String, dynamic>>> updateNotification({
    required int ownerId,
    required List<int> notificationIds,
  }) async {
    try {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      final response = await _dio.put(
        AppUrls.updateNotification,
        data: {
          "owner": ownerId,
          "ids": notificationIds,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List<dynamic>
        List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Failed to update notifications.");
      }
    } catch (error) {
      print("Update Notification Error: $error");
      throw Exception("An error occurred while updating notifications: $error");
    }
  }
}
