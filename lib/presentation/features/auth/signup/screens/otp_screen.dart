import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_password_screen.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final bool isFromSignIn;
  final bool isFromRecoverPassword;
  final bool isFromSignupWithEmail;

  const OtpVerificationScreen({
    super.key,
    required this.isFromSignIn,
    this.isFromRecoverPassword = false,
    this.isFromSignupWithEmail = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isNotEmpty && index == _focusNodes.length - 1) {
      _focusNodes[index].unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.isFromRecoverPassword
        ? "Recover Password"
        : widget.isFromSignIn
            ? widget.isFromSignupWithEmail
                ? "Let's Confirm Your Email"
                : "Enter OTP Code" // Title for Sign In with Number
            : "Enter OTP Code";

    final String description = widget.isFromRecoverPassword
        ? "A verification code was sent to your email address. Enter the code to reset your password."
        : widget.isFromSignupWithEmail
            ? "A verification code was sent to peternjenga@glitex.com. Enter the code and confirm your email address."
            : widget.isFromSignIn
                ? widget.isFromSignupWithEmail
                    ? "A verification code was sent to peternjenga@glitex.com. Enter the code and verify your email address."
                    : "A verification code was sent to +254 712 345 678. Enter the code to verify your phone number."
                : "A verification code was sent to +254 712 345 678. Enter the code and verify your phone number.";

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          false, // Prevent UI elements from moving when keyboard pops up
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
                      children: List.generate(5, (index) {
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
                                  color: primaryColor.withOpacity(
                                      0.11), // Default border color
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(
                                      0.11), // Same color when focused
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: primaryColor.withOpacity(
                                      0.11), // Same color when enabled
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
                        Text(
                          "Request Code in 23",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF000EF8),
                            fontWeight: FontWeight.w500,
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
                text: "Complete Verification",
                onPressed: () {
                  if (widget.isFromRecoverPassword) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CreatePasswordScreen(isFromSignup: false),
                      ),
                    );
                  } else if (widget.isFromSignIn) {
                    // Handle sign-in verification logic
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CreatePasswordScreen(isFromSignup: true),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}
