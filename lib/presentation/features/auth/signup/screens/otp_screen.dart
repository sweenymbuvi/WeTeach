import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_password_screen.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final bool isFromSignIn;
  final bool isFromRecoverPassword;
  final bool isFromSignupWithEmail;
  final String? email;
  final String? phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.isFromSignIn,
    this.isFromRecoverPassword = false,
    this.isFromSignupWithEmail = false,
    this.email,
    this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendCountdown = 30;
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      }
    });
  }

  void _resendOtp() async {
    if (_canResend) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success;

      if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
        // Resend OTP for phone number
        success = await authProvider.resendOtpPhone(widget.phoneNumber ?? "",
            phoneNumber: widget.phoneNumber ?? "");
      } else {
        // Resend OTP for email
        success = await authProvider.resendOtp(widget.email ?? "",
            email: widget.email ?? "");
      }

      if (success) {
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New OTP sent successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(authProvider.errorMessage ?? "Failed to resend OTP")),
        );
      }
    }
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isNotEmpty && index == _focusNodes.length - 1) {
      _focusNodes[index].unfocus();
    }
  }

  Future<void> _submitOtp(BuildContext context) async {
    String otp = _controllers.map((controller) => controller.text).join('');
    if (otp.length == 6) {
      final int otpCode = int.parse(otp);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool isSuccess = await authProvider.confirmOtp(otpCode: otpCode);
      if (isSuccess) {
        if (widget.isFromRecoverPassword) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreatePasswordScreen(isFromSignup: false, otp: otpCode),
            ),
          );
        } else if (widget.isFromSignIn) {
          // Handle sign-in verification logic here
        } else if (widget.isFromSignupWithEmail) {
          // For sign-up with email and phone number, navigate to CreatePasswordScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePasswordScreen(
                isFromSignup: true, // Adjust based on your logic
                otp: otpCode, // Pass OTP here
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreatePasswordScreen(isFromSignup: true, otp: otpCode),
            ),
          );
        }
      } else {
        // Show error if OTP confirmation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(authProvider.errorMessage ?? "Failed to verify OTP")),
        );
      }
    } else {
      // Show error if OTP is incomplete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String title = widget.isFromRecoverPassword
        ? "Recover Password"
        : widget.isFromSignIn
            ? widget.isFromSignupWithEmail
                ? "Let's Confirm Your Email"
                : "Enter OTP Code"
            : "Enter OTP Code";

    final String description = widget.isFromRecoverPassword
        ? "A verification code was sent to your email address. Enter the code to reset your password."
        : widget.isFromSignupWithEmail
            ? "A verification code was sent to ${widget.email ?? 'your email address'}. Enter the code and confirm your email address."
            : widget.isFromSignIn
                ? widget.isFromSignupWithEmail
                    ? "A verification code was sent to ${widget.email ?? 'your email address'}. Enter the code and verify your email address."
                    : "A verification code was sent to ${widget.phoneNumber ?? ''}. Enter the code to verify your phone number."
                : "A verification code was sent to ${widget.phoneNumber ?? ''}. Enter the code and verify your phone number.";

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF5C5C5C),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Text(
                      "Verification Code",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.width * 0.12,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.11),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.11),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(0.11),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * 0.03,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                            onChanged: (value) => _onDigitEntered(index, value),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: [
                        Text(
                          "Didn't get the code?",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        GestureDetector(
                          onTap: _canResend ? _resendOtp : null,
                          child: Text(
                            _canResend
                                ? "Resend Code"
                                : "Request Code in $_resendCountdown s",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color:
                                  _canResend ? Color(0xFF000EF8) : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: CustomButton(
                text: authProvider.isLoading
                    ? 'Processing...'
                    : (widget.isFromSignupWithEmail
                        ? "Create Account"
                        : "Complete Verification"),
                onPressed: !authProvider.isLoading
                    ? () async {
                        await _submitOtp(context);
                      }
                    : null,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}
