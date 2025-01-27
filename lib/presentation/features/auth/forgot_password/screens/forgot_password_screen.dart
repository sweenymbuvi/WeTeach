import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/otp_screen.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  void onRequestCodeClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
            isFromSignIn: false, isFromRecoverPassword: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      // Set border color for all states (enabled, focused, etc.)
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
                        text: 'Request Code',
                        onPressed: onRequestCodeClick,
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
