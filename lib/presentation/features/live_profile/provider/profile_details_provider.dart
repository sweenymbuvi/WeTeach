import 'package:flutter/material.dart';
import 'package:we_teach/data/repositories/auth/live_profile_repo.dart';

class ProfileDetailsProvider with ChangeNotifier {
  final LiveProfileRepository _repository = LiveProfileRepository();
  Map<String, dynamic>? _userData;
  bool _recentProfilePostIsActive = false;
  Map<String, dynamic>? _teacherProfile;
  Map<String, dynamic>? _recentProfilePost;
  Map<String, dynamic>? get recentProfilePost => _recentProfilePost;
  int? _paymentId; // Keep this private
  String? _paymentStatus;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Map<String, dynamic>? get userData => _userData;
  Map<String, dynamic>? get teacherProfile => _teacherProfile;
  String? get paymentStatus => _paymentStatus;
  bool get recentProfilePostIsActive => _recentProfilePostIsActive;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Public getter for _paymentId
  int? get paymentId => _paymentId; // Add this line

  // Fetch user data
  Future<void> fetchUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userData = await _repository.fetchUserData();

      if (_userData != null) {
        // Extract recent profile post data
        final recentProfilePost = _userData?["profile_post"];

        // Extract is_active status from recent profile post
        _recentProfilePostIsActive = recentProfilePost?["is_active"] ?? false;

        // Store full profile post data for potential later use
        _recentProfilePost = recentProfilePost;

        // Print the is_active status
        print("Recent Profile Post is_active: $_recentProfilePostIsActive");
        print("Profile Post Details: $_recentProfilePost");
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("Error fetching user data: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch teacher profile post
  Future<void> fetchTeacherProfilePost() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.fetchTeacherProfilePost();

      if (response != null) {
        // Extract the ID and other necessary fields
        _recentProfilePost = {
          'id': response['id'],
          'views': response['views'] ?? 0.0,
          'is_active': response['is_active'] ?? false,
          'expiry_time': response['expiry_time'],
          'creation_time': response['creation_time'],
          'last_updated_time': response['last_updated_time'],
        };

        // Optionally, you can also set the active status
        _recentProfilePostIsActive = response['is_active'] ?? false;

        // Print the fetched profile post details
        print("Fetched Teacher Profile Post: $_recentProfilePost");
      } else {
        throw Exception("No profile post data found.");
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("Error fetching teacher profile post: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete teacher profile post
  Future<void> deleteTeacherProfilePost() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_recentProfilePost != null) {
        final postId = _recentProfilePost!['id']; // Get the post ID

        await _repository
            .deleteTeacherProfilePost(postId); // Call the delete method

        // Optionally, you can clear the recent profile post data
        _recentProfilePost = null;
        _recentProfilePostIsActive = false;

        print("Successfully deleted teacher profile post with ID: $postId");
      } else {
        throw Exception("No recent profile post to delete.");
      }
    } catch (error) {
      _errorMessage = error.toString();
      print("Error deleting teacher profile post: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Post teacher profile
  Future<void> postTeacherProfile() async {
    if (_userData == null) {
      await fetchUserData(); // Ensure we have user data before posting
    }

    if (_userData != null) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        int teacherId = _userData!['teacher_id'];
        _teacherProfile = await _repository.postTeacherProfile(teacherId);
      } catch (error) {
        _errorMessage = error.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      _errorMessage = "Failed to retrieve user data.";
      notifyListeners();
    }
  }

  // Make profile live
  Future<void> makeProfileLive({
    required String phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ensure user data is fetched
      if (_userData == null) {
        await fetchUserData();
      }

      if (_userData != null && _teacherProfile != null) {
        final int ownerId = _userData!['user_id'];
        final int teacherProfilePostId = _teacherProfile!['id'];

        // Make the payment to make the profile live
        final response = await _repository.makeProfileLive(
          phoneNumber: phoneNumber,
          teacherProfilePost: teacherProfilePostId,
          postingRate: 7,
          owner: ownerId,
        );

        if (response != null && response.containsKey('payment')) {
          _paymentId = response['payment']['id']; // Store the payment ID
          await checkPaymentStatus(
              paymentId: _paymentId!); // Check payment status
        }
      } else {
        _errorMessage = "User  data or teacher profile is not available.";
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check Payment Status
  Future<void> checkPaymentStatus({
    required int paymentId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final paymentStatusResponse = await _repository.checkPaymentStatus(
        paymentId: paymentId,
      );

      _paymentStatus = paymentStatusResponse['payment_status'];

      if (_paymentStatus == 'Paid') {
        _paymentStatus = "Payment Successful ✅";
      } else {
        _paymentStatus = "Payment Failed ❌";
      }
    } catch (error) {
      _errorMessage = "Error checking payment status: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
