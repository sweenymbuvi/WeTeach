import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentRepository {
  final String baseUrl =
      'https://api.mwalimufinder.com/api/v1/payments/user/methods/';
  final String paymentUrl =
      'https://api.mwalimufinder.com/api/v1/payments/mpesa/view/make/';
  final String userUrl = 'https://api.mwalimufinder.com/api/v1/users/teacher/';

  // Fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String accessToken) async {
    final url = Uri.parse(userUrl);
    try {
      print("Sending API Request to: $url");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print("Status Code: \${response.statusCode}");
      print("Response Body: \${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          final user = responseData[0];
          return {
            'teacher_id': user['id'],
            'user_id': user['user']['id'],
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

  // Fetch available payment methods
  Future<List<Map<String, dynamic>>> fetchPaymentMethods(
      String accessToken) async {
    final url = Uri.parse(baseUrl);

    try {
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

      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

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

  Future<Map<String, dynamic>> makePayment({
    required String accessToken,
    required String phoneNumber,
    required int jobId,
  }) async {
    final url = Uri.parse(paymentUrl);

    try {
      // Fetch user details to get the user ID
      final userData = await fetchUserData(accessToken);
      if (userData == null || !userData.containsKey('user_id')) {
        throw Exception("User ID not found.");
      }

      final int ownerId = userData['user_id'];

      final body = jsonEncode({
        'phone_number': phoneNumber,
        'job': jobId,
        'amount': 1, // Always send 1 as the amount
        'owner': ownerId,
      });

      print("Making Payment Request to: $url");
      print("Request Body: $body");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final payment = responseData['payment'];

        return {
          'message': responseData['message'],
          'payment': {
            'id': payment['id'],
            'transaction_id': payment['transaction_id'],
            'checkout_request_id': payment['checkout_request_id'],
            'payment_status': payment['payment_status'],
            'payment_method': payment['payment_method'],
            'amount': payment['amount'],
            'purpose': payment['purpose'],
            'checked_out': payment['checked_out'],
            'creation_time': payment['creation_time'],
            'last_updated_time': payment['last_updated_time'],
            'owner': payment['owner'],
          },
        };
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? "Payment failed.");
      }
    } catch (error) {
      print("Error making payment: $error");
      throw Exception("An error occurred while making payment: $error");
    }
  }

  Future<Map<String, dynamic>> checkPaymentStatus({
    required String accessToken,
    required int paymentId,
  }) async {
    final url = Uri.parse(
        'https://api.mwalimufinder.com/api/v1/payments/mpesa/confirm/$paymentId/');

    try {
      print("Checking Payment Status from: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final paymentData = responseData['payment'];

        return {
          'id': paymentData['id'],
          'transaction_id': paymentData['transaction_id'],
          'checkout_request_id': paymentData['checkout_request_id'],
          'payment_status': paymentData['payment_status'],
          'payment_method': paymentData['payment_method'],
          'amount': paymentData['amount'],
          'purpose': paymentData['purpose'],
          'checked_out': paymentData['checked_out'],
          'creation_time': paymentData['creation_time'],
          'last_updated_time': paymentData['last_updated_time'],
          'owner': paymentData['owner'],
        };
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            responseData['message'] ?? "Failed to check payment status.");
      }
    } catch (error) {
      print("Error checking payment status: $error");
      throw Exception(
          "An error occurred while checking payment status: $error");
    }
  }
}
