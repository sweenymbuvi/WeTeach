import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/account_profile.dart';
import 'package:we_teach/presentation/features/auth/signup/widgets/password_field_widget.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class CreatePasswordScreen extends StatefulWidget {
  final bool isFromSignup;

  const CreatePasswordScreen({super.key, required this.isFromSignup});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final borderColor =
      Color(0x00476be8).withOpacity(0.11); // Define the border color

  @override
  Widget build(BuildContext context) {
    // Get screen width
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
              SizedBox(
                height: screenWidth *
                    0.8, // Add extra space before the button based on screen width
              ),
              CustomButton(
                text: widget.isFromSignup ? "Create Account" : "Complete",
                onPressed: () {
                  if (widget.isFromSignup) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountProfileScreen(),
                      ),
                    );
                  } else {
                    // Handle password reset completion logic
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
