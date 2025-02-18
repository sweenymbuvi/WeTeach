import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/otp_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/signup_number.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isAgreed = false;
  final TextEditingController emailController = TextEditingController();

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
                        "Email Address ",
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
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: Color(0xFF828282)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/svg/email.svg',
                            height: 5, width: 5, fit: BoxFit.scaleDown),
                      ),
                      fillColor: Color(0xFFFDFDFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0x00476be8).withOpacity(0.11),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0x00476be8).withOpacity(0.11),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0x00476be8).withOpacity(0.11),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  Row(
                    children: [
                      Checkbox(
                        value: isAgreed,
                        activeColor: Color(0xFF000EF8),
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
                                  color: Color(0xFF000EF8),
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
                                  color: Color(0xFF000EF8),
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
                              final success = await authProvider.registerUser(
                                email: emailController.text.trim(),
                              );
                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpVerificationScreen(
                                      isFromSignIn: false,
                                      isFromSignupWithEmail: true,
                                      email: emailController.text,
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
                                color: Color(0xFF000EF8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: screenWidth * 0.1), // Add space before buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
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
                                  color: Color(0xFF1F1F1F),
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
                            // Handle "Continue with Phone Number"
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignupNumberScreen()));
                          },
                          icon: Icon(
                            Icons.phone,
                            size: 18,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Continue with Phone Number",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
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
