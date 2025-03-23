import 'package:dio/dio.dart';
import 'package:we_teach/constants/app_urls.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class ViewSchoolRepository {
  final Dio _dio = Dio();
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<List<Map<String, dynamic>>?> fetchSchoolPhotos(int schoolId) async {
    try {
      // Retrieve access token
      String? accessToken = await _secureStorageService.getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }

      // Send GET request with headers
      Response response = await _dio.get(
        "${AppUrls.schoolPhotosUrl}$schoolId",
        options: Options(
          headers: {"Authorization": "Bearer $accessToken"},
        ),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Failed to load school photos");
      }
    } catch (e) {
      print("Error fetching school photos: $e");
      return null;
    }
  }
}
