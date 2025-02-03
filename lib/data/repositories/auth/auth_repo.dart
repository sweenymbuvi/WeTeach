import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  static const String _baseUrl = "https://api.mwalimufinder.com/api/v1/";
  static const String _registerEndpoint = "users/register/";
  static const String _registerWithOtpEndpoint = "users/register/otp/";
  static const String _confirmOtpEndpoint = "users/otp/confirm/";
  static const String _resendOtpEndpoint = "users/otp/resend/";
  static const String _resendOtpPhoneEndpoint = "users/otp/phone/resend/";
  static const String _setPasswordEndpoint = "users/otp/set/password/";
  static const String _loginEndpoint = "auth/token/";
  static const String _loginWithPhoneEndpoint = "users/otp/login/";
  static const String _countiesEndpoint = "users/counties/";
  static const String _subCountiesEndpoint = "users/sub-scounties/list/";

  static Future<http.Response> registerUser({
    required String email,
    required bool isTeacher,
  }) async {
    final url = Uri.parse("$_baseUrl$_registerEndpoint");
    final body = jsonEncode({
      "email": email,
      "is_teacher": isTeacher,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to register user: \${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to register user: \$e");
    }
  }

  static Future<http.Response> registerWithPhoneNumber({
    required String phoneNumber,
    required bool isTeacher,
  }) async {
    final url = Uri.parse("$_baseUrl$_registerWithOtpEndpoint");
    final body = jsonEncode({
      "phone_number": phoneNumber,
      "is_teacher": isTeacher,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to register user: \${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to register user: \$e");
    }
  }

  static Future<http.Response> confirmOtp({
    required int otpCode,
  }) async {
    final url = Uri.parse("$_baseUrl$_confirmOtpEndpoint");
    final body = jsonEncode({
      "otp_code": otpCode,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to confirm OTP: \${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to confirm OTP: \$e");
    }
  }

  static Future<http.Response> resendOtp({
    required String email,
  }) async {
    final url = Uri.parse("$_baseUrl$_resendOtpEndpoint");
    final body = jsonEncode({
      "email": email,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to resend OTP: \${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to resend OTP: \$e");
    }
  }

  static Future<http.Response> resendOtpPhone({
    required String phoneNumber,
  }) async {
    final url = Uri.parse("$_baseUrl$_resendOtpPhoneEndpoint");
    final body = jsonEncode({
      "phone_number": phoneNumber,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to resend OTP to phone: \${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to resend OTP to phone: \$e");
    }
  }

  static Future<http.Response> createPassword({
    required int otpCode,
    required String password,
    required String password2,
  }) async {
    final url = Uri.parse("$_baseUrl$_setPasswordEndpoint");
    final body = jsonEncode({
      "otp_code": otpCode,
      "password": password,
      "password2": password2,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to set password: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to set password: $e");
    }
  }

  // Sign-in logic
  static Future<http.Response> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl$_loginEndpoint");
    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Handle successful login response
        return response;
      } else {
        throw Exception("Failed to sign in: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }

  static Future<http.Response> signInWithPhoneNumber({
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl$_loginWithPhoneEndpoint");
    final body = jsonEncode({
      "phone_number": phoneNumber,
      "password": password,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            "Failed to sign in with phone number: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to sign in with phone number: $e");
    }
  }

  static Future<List<Map<String, String>>> fetchCounties(
      String accessToken) async {
    final url = Uri.parse("$_baseUrl$_countiesEndpoint");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        // Map each county to a Map containing both name and id
        return responseData.map((county) {
          return {
            'name': county['name'] as String,
            'id': county['id'].toString(),
          };
        }).toList();
      } else {
        throw Exception("Failed to fetch counties: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching counties: $e");
    }
  }

  static Future<List<Map<String, String>>> fetchSubCounties(
      String countyId, String accessToken) async {
    final url =
        Uri.parse("$_baseUrl$_subCountiesEndpoint?county__id=$countyId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken", // Include the access token
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        // Map each sub-county to a Map containing both name and id
        return responseData.map((subCounty) {
          return {
            'name': subCounty['name'] as String,
            'id':
                subCounty['id'].toString(), // Convert ID to string if necessary
          };
        }).toList();
      } else {
        throw Exception("Failed to fetch sub-counties: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching sub-counties: $e");
    }
  }
}
