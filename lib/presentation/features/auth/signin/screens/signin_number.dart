import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/gen/assets.gen.dart';
import 'package:we_teach/presentation/features/auth/forgot_password/screens/forgot_password_screen.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/screens/create_account_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class SignInNumberScreen extends StatefulWidget {
  const SignInNumberScreen({super.key});

  @override
  _SignInNumberScreenState createState() => _SignInNumberScreenState();
}

class _SignInNumberScreenState extends State<SignInNumberScreen> {
  bool _obscurePassword = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _completePhoneNumber = '';
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    _secureStorageService.storeLastVisitedScreen('SignInNumberScreen');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInScreen())),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Text(
                          "Sign In",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.06),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02),
                        IntlPhoneField(
                          controller: _phoneController,
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
                                color:
                                    const Color(0x00476be8).withOpacity(0.11),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    const Color(0x00476be8).withOpacity(0.11),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    const Color(0x00476be8).withOpacity(0.11),
                              ),
                            ),
                          ),
                          initialCountryCode: 'KE',
                          onChanged: (phone) {
                            // Store the complete phone number
                            _completePhoneNumber = phone.completeNumber;
                          },
                          disableLengthCheck: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05),
                        Row(
                          children: [
                            Text(
                              "Password ",
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
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Enter password",
                            hintStyle: TextStyle(color: Color(0xFF828282)),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                Assets
                                    .svg.lock, // Use the generated asset class
                                height: 5,
                                width: 5,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            fillColor: Color(0xFFFDFDFF),
                            filled: true,
                            border: OutlineInputBorder(
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color(0x00476be8).withOpacity(0.11),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                            },
                            child: Text(
                              "Forgot password?",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF000EF8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.1),
                        CustomButton(
                          text: authProvider.isLoading
                              ? 'Signing In...'
                              : 'Sign In',
                          onPressed: !authProvider.isLoading
                              ? () async {
                                  final password =
                                      _passwordController.text.trim();

                                  if (_completePhoneNumber.isEmpty ||
                                      password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Please fill in all fields."),
                                      ),
                                    );
                                    return;
                                  }

                                  final success =
                                      await authProvider.signInWithPhoneNumber(
                                    phoneNumber: _completePhoneNumber,
                                    password: password,
                                  );

                                  if (success) {
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Sign In successful!"),
                                      ),
                                    );
                                    _phoneController.clear();
                                    _passwordController.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authProvider.errorMessage ??
                                              "Sign-in failed.",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.03),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateAccountScreen()),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Create one",
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
                            height: MediaQuery.of(context).size.width * 0.03),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Or",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
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
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.03),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle "Continue with Email"
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignInScreen()));
                                },
                                icon: const Icon(Icons.email_outlined,
                                    color: Colors.black),
                                label: Text(
                                  "Continue with Email",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
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
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.04),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle "Continue with Google"
                                },
                                icon: Image.asset(
                                  Assets.images.googleIcon
                                      .path, // Use the generated asset class
                                  height: 20,
                                ),
                                label: Text(
                                  "Continue with Google",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
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
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.04),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
