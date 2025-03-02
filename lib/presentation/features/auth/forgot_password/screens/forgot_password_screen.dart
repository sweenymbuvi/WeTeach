import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/otp_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    _secureStorageService.storeLastVisitedScreen('ForgotPasswordScreen');
  }

  void onRequestCodeClick() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email.")),
      );
      return;
    }

    // Call the sendOtpForPasswordReset method
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtpForPasswordReset(email: email);

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to your email.")),
      );

      // Navigate to the OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            isFromSignIn: false,
            isFromRecoverPassword: true,
            email: email,
          ),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to send OTP: ${authProvider.errorMessage}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
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
                    "Recover Password",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  Text(
                    "A verification code will be sent to your email address. Please confirm your email and request code.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5C5C5C),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  Row(
                    children: [
                      Text(
                        "Confirm Email",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        "*",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  TextField(
                    controller: emailController,
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: "peternjenga@glitex.com",
                      hintStyle: TextStyle(color: Color(0xFF828282)),
                      prefixIcon: SvgPicture.asset('assets/svg/email.svg',
                          height: 5, width: 5, fit: BoxFit.scaleDown),
                      fillColor: Color(0xFFFDFDFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Color(0x00476be8).withOpacity(0.11)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0x00476be8).withOpacity(
                              0.11), // Border color for enabled state
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0x00476be8)
                              .withOpacity(0.11), // Border color when focused
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          screenWidth * 0.7), // Reduced space to move button up
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 0.0), // Removed bottom padding
                      child: CustomButton(
                        text: authProvider.isLoading
                            ? 'Processing...'
                            : 'Request Code',
                        onPressed:
                            !authProvider.isLoading ? onRequestCodeClick : null,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
