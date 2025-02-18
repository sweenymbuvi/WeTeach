import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_account_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

class SignupNumberScreen extends StatefulWidget {
  const SignupNumberScreen({super.key});

  @override
  _SignupNumberScreenState createState() => _SignupNumberScreenState();
}

class _SignupNumberScreenState extends State<SignupNumberScreen> {
  bool isAgreed = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  String _completePhoneNumber = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenWidth * 0.04),
                  Text(
                    "Create an Account",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  Row(
                    children: [
                      Text(
                        "Phone Number ",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "*",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  IntlPhoneField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      hintText: "712345678",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF333333),
                      ),
                      fillColor: const Color(0xFFFDFDFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: const Color(0x00476be8).withOpacity(0.11),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: const Color(0x00476be8).withOpacity(0.11),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: const Color(0x00476be8).withOpacity(0.11),
                        ),
                      ),
                    ),
                    initialCountryCode:
                        'KE', // Default country code set to Kenya
                    onChanged: (PhoneNumber phone) {
                      // Store the complete phone number
                      _completePhoneNumber = phone.completeNumber;
                    },
                    disableLengthCheck: true,
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  Row(
                    children: [
                      Checkbox(
                        value: isAgreed,
                        activeColor: const Color(0xFF000EF8),
                        onChanged: (value) {
                          setState(() {
                            isAgreed = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "By creating an account, you agree to the ",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "Privacy policy",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: const Color(0xFF000EF8),
                                ),
                              ),
                              const TextSpan(
                                text: " & ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "Service Agreement.",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: const Color(0xFF000EF8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CustomButton(
                      text:
                          authProvider.isLoading ? 'Signing Up...' : 'Sign Up',
                      onPressed: isAgreed && !authProvider.isLoading
                          ? () async {
                              final success =
                                  await authProvider.registerWithPhoneNumber(
                                phoneNumber: _completePhoneNumber,
                              );
                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpVerificationScreen(
                                      isFromSignIn: false,
                                      isFromSignupWithEmail: false,
                                      phoneNumber: _completePhoneNumber,
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: const Color(0xFF000EF8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: screenWidth *
                          0.05), // Added some space here for clarity
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Or",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenWidth * 0.04),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen()));
                        },
                        icon: const Icon(Icons.email_outlined,
                            color: Colors.black),
                        label: Text(
                          "Continue with Email",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(
                              color: Color(0xFFDADADA), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                          elevation: 0,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.04),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle "Continue with Google"
                        },
                        icon: Image.asset(
                          'assets/images/google_icon.png',
                          height: 20,
                        ),
                        label: Text(
                          "Continue with Google",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(
                              color: Color(0xFFDADADA), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                          elevation: 0,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.04),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
