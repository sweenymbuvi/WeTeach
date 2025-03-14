import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/account_profile.dart';
import 'package:we_teach/presentation/features/auth/signin/screens/signin_screen.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/features/auth/signup/widgets/password_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class CreatePasswordScreen extends StatefulWidget {
  final bool isFromSignup;

  const CreatePasswordScreen({
    super.key,
    required this.isFromSignup,
  });

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  int? otp; // Store OTP here
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final borderColor = Color(0x00476be8).withOpacity(0.11);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    SecureStorageService().storeLastVisitedScreen('CreatePasswordScreen');
    // Initialize auth state
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadTokens(); // Load tokens when screen initializes
    _loadOtp(); // Load OTP after initializing auth state
  }

  Future<void> _loadOtp() async {
    otp = await _secureStorageService.getOtpCode();
    setState(() {}); // Update the state to reflect the loaded OTP
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                "Create a Password",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: "Create Password",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              PasswordField(
                controller: passwordController,
                hintText: "Enter password",
                isPasswordVisible: isPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                fillColor: Color(0xFFFDFDFF),
                borderColor: borderColor,
              ),
              if (passwordController.text.length > 0 &&
                  passwordController.text.length < 8)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Password must be at least 8 characters long",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: "Confirm Password",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              PasswordField(
                controller: confirmPasswordController,
                hintText: "Repeat password",
                isPasswordVisible: isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
                fillColor: Color(0xFFFDFDFF),
                borderColor: borderColor,
              ),
              SizedBox(height: screenWidth * 0.8),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: authProvider.isLoading
                        ? 'Processing...'
                        : (widget.isFromSignup ? "Create Account" : "Complete"),
                    onPressed: !authProvider.isLoading
                        ? () async {
                            if (passwordController.text.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Password must be at least 8 characters long")),
                              );
                              return;
                            }
                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Passwords do not match")),
                              );
                              return;
                            }

                            bool result = await authProvider.setPassword(
                              otpCode: otp ?? 0, // Use the loaded OTP
                              password: passwordController.text.trim(),
                              password2: confirmPasswordController.text.trim(),
                            );

                            if (result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Password set successfully!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => widget.isFromSignup
                                      ? AccountProfileScreen()
                                      : SignInScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        authProvider.errorMessage ?? "Error")),
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
