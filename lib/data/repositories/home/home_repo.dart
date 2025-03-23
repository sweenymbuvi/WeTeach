import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:we_teach/constants/app_urls.dart';

class HomeRepository {
  // Use the URLs from AppUrls
  final String baseUrl = AppUrls.getTeacherDetails;
  final String jobsBaseUrl = AppUrls.jobsBaseUrl;

  // Fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String accessToken) async {
    final url = Uri.parse(baseUrl);

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

          // Extract school information including accommodation and gender
          String? accommodation = user['school']?['accommodation'];
          String? gender = user['school']?['gender'];

          // Extract teacher requirements
          final List<dynamic> teacherRequirements =
              user['teacher_requirements'] ?? [];
          final List<String> requirementNames = teacherRequirements
              .map<String>((requirement) => requirement['name'] as String)
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
            // Added new fields
            'accommodation': accommodation,
            'gender': gender,
            'teacher_requirements': requirementNames,
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

        // Debugging: Print the raw response data
        print("Raw Response Data: $responseData");

        return responseData.map<Map<String, dynamic>>((job) {
          // Debugging: Print the raw job data
          print("Raw Job Data: $job");

          // Extract creation time and format it
          String creationTime = job['creation_time'];
          String formattedCreationTime = _formatJoinedDate(creationTime);

          // Extract school image URL and transform it if needed
          String imageUrl = '';
          if (job['school'] != null &&
              job['school']['image'] != null &&
              job['school']['image'].toString().isNotEmpty) {
            String originalUrl = job['school']['image'];

            // Replace localhost URLs with production URL
            if (originalUrl.contains('localhost')) {
              int mediaIndex = originalUrl.indexOf('/media/');
              if (mediaIndex >= 0) {
                String imagePath = originalUrl.substring(mediaIndex);
                imageUrl = 'https://api.mwalimufinder.com$imagePath';
              } else {
                imageUrl = originalUrl;
              }
            } else {
              imageUrl = originalUrl;
            }
          }

          // Debugging: Print the extracted image URL
          print("Extracted Image URL: $imageUrl");

          // Extract teacher requirements names
          List<String> teacherRequirements = [];
          if (job['teacher_requirements'] != null) {
            // Debugging: Print the raw teacher requirements data
            print("Raw Teacher Requirements: ${job['teacher_requirements']}");

            teacherRequirements =
                (job['teacher_requirements'] as List).map((requirement) {
              // Debugging: Print each requirement
              print("Requirement: $requirement");

              // Ensure the requirement is a map and contains the 'name' key
              if (requirement is Map<String, dynamic> &&
                  requirement.containsKey('name')) {
                return requirement['name'].toString();
              } else {
                // Debugging: Print if the requirement is invalid
                print("Invalid Requirement: $requirement");
                return '';
              }
            }).toList();

            // Debugging: Print the extracted teacher requirements names
            print("Extracted Teacher Requirements Names: $teacherRequirements");
          }

          // Extract gender and accommodation
          String gender = 'Unknown';
          String accommodation = 'Unknown';
          if (job['school'] != null) {
            // Debugging: Print the raw school data
            print("Raw School Data: ${job['school']}");

            gender = job['school']['gender']?.toString() ?? 'Unknown';
            accommodation =
                job['school']['accommodation']?.toString() ?? 'Unknown';

            // Debugging: Print the extracted gender and accommodation
            print("Extracted Gender: $gender");
            print("Extracted Accommodation: $accommodation");
          }

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
            'gender': gender, // Extract gender
            'accommodation': accommodation, // Extract accommodation
            'teacher_requirements':
                teacherRequirements, // Extract teacher requirement names
            'creation_time':
                formattedCreationTime, // Add formatted creation time
            'image': imageUrl, // Add the transformed image URL
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
    final url = Uri.parse('${jobsBaseUrl}saves/');

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
