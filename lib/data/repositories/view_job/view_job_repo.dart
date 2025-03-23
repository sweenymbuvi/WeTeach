import 'package:dio/dio.dart';
import 'package:we_teach/constants/app_urls.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class ViewJobRepository {
  final Dio _dio = Dio();
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, dynamic>?> fetchJobDetails(int jobId) async {
    try {
      // Retrieve access token
      String? accessToken = await _secureStorageService.getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }

      // Send GET request with headers
      Response response = await _dio.get(
        "${AppUrls.viewJobUrl}$jobId",
        options: Options(
          headers: {"Authorization": "Bearer $accessToken"},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load job details");
      }
    } catch (e) {
      print("Error fetching job details: $e");
      return null;
    }
  }
}
