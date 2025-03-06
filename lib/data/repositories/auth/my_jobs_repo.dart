import 'package:dio/dio.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class MyJobsRepository {
  final Dio _dio = Dio();
  final SecureStorageService _secureStorage = SecureStorageService();
  final String _savedJobsUrl =
      "https://api.mwalimufinder.com/api/v1/jobs/saves/";
  final String _viewedJobsUrl =
      "https://api.mwalimufinder.com/api/v1/jobs/user/viewed/";
  final String _deleteSavedJobUrl =
      "https://api.mwalimufinder.com/api/v1/jobs/saves/delete/";

  Future<List<Map<String, dynamic>>> fetchSavedJobs() async {
    try {
      // Get the access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      // Make the API request
      final response = await _dio.get(
        _savedJobsUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((job) => job as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to fetch saved jobs.");
      }
    } catch (error) {
      print("Fetch Saved Jobs Error: $error");
      throw Exception("An error occurred while fetching saved jobs: $error");
    }
  }

  Future<List<Map<String, dynamic>>> fetchViewedJobs() async {
    try {
      // Get the access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      // Make the API request
      final response = await _dio.get(
        _viewedJobsUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          // Ensure the response contains the "jobs" key and extract correctly
          if (response.data.containsKey("jobs") &&
              response.data["jobs"] is List) {
            return List<Map<String, dynamic>>.from(response.data["jobs"]);
          } else {
            throw Exception(
                "Invalid response format: 'jobs' key missing or not a list.");
          }
        } else {
          throw Exception("Unexpected response format.");
        }
      } else {
        throw Exception("Failed to fetch viewed jobs.");
      }
    } catch (error) {
      print("Fetch Viewed Jobs Error: $error");
      throw Exception("An error occurred while fetching viewed jobs: $error");
    }
  }

  Future<void> deleteSavedJob(int savedId) async {
    try {
      // Get the access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception("Not authenticated. Please log in.");
      }

      print("Delete Request Details:");
      print("URL: ${"$_deleteSavedJobUrl$savedId/"}");
      print("Access Token: $accessToken");

      try {
        final response = await _dio.delete(
          "$_deleteSavedJobUrl$savedId/",
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ),
          data: {"id": savedId}, // Remove this if not required by your backend
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");

        // Check for 200 and 201 status codes
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception(
              "Failed to delete saved job. Status code: ${response.statusCode}");
        }

        // Optionally, you can check the response message
        if (response.data is Map &&
            (response.data as Map)['message'] !=
                'User Job Save deleted successfully') {
          throw Exception("Unexpected response message");
        }

        return; // Successfully deleted
      } on DioError catch (dioError) {
        print("Dio Error Details:");
        print("Error Response: ${dioError.response?.data}");
        print("Error Status Code: ${dioError.response?.statusCode}");

        // Check if the error response is actually a successful deletion
        if (dioError.response?.statusCode == 200 ||
            dioError.response?.statusCode == 201) {
          return; // Silently handle as successful
        }

        throw Exception("Dio Error: ${dioError.message}");
      }
    } catch (error) {
      print("Complete Delete Saved Job Error: $error");
      throw Exception("An error occurred while deleting saved job: $error");
    }
  }
}
