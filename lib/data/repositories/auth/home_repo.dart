import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeRepository {
  final String baseUrl = "https://api.mwalimufinder.com/api/v1/users/";
  final String jobsBaseUrl = "https://api.mwalimufinder.com/api/v1/jobs/";

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
          final teacherId = user['id']; // This is the teacher profile ID
          final userId = user['user']['id']; // This is the user ID

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
            'teacher_id': teacherId,
            'user_id': userId,
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

  // Fetch job data
  Future<List<Map<String, dynamic>>> fetchJobData(String accessToken) async {
    final url = Uri.parse('$jobsBaseUrl/all/');

    try {
      // Print request details
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("Authorization: Bearer $accessToken");
      print("Content-Type: application/json");
      print("Accept: application/json");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // Print response details
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map<Map<String, dynamic>>((job) {
          // Extract creation time and format it
          String creationTime = job['creation_time'];
          String formattedCreationTime = _formatJoinedDate(creationTime);

          return {
            'id': job['id'],
            'title': job['title'],
            'duties_and_responsibilities': job['duties_and_responsibilities'],
            'minimum_requirements': job['minimum_requirements'],
            'status': job['status'],
            'how_to_apply': job['how_to_apply'],
            'deadline': job['deadline'],
            'school_name': job['school']['name'],
            'school_phone': job['school']['phone_number'],
            'school_email': job['school']['primary_email'],
            'county': job['school']['county']['name'], // Extract county name
            'sub_county': job['school']['sub_county']
                ['name'], // Extract sub-county name
            'creation_time':
                formattedCreationTime, // Add formatted creation time
          };
        }).toList();
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? "Failed to fetch job data.");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("An error occurred while fetching job data: $error");
    }
  }

  // Helper method to format the joined date
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

// Save job method
  Future<bool> saveJob(int userId, int jobId, String accessToken) async {
    final url = Uri.parse('$jobsBaseUrl/saves/');

    try {
      print("Sending API Request to: $url");
      print("Request Headers: {");
      print("Authorization: Bearer $accessToken");
      print("Content-Type: application/json");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'owner': userId,
          'job': jobId,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Job saved successfully
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? "Failed to save job.");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("An error occurred while saving the job: $error");
    }
  }
}
