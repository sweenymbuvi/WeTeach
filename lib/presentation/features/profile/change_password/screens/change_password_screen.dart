import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/widgets/password_field_widget.dart';
import 'package:we_teach/presentation/features/profile/change_password/provider/change_password_provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  final borderColor = Color(0x00476be8).withOpacity(0.11);

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(width: 8),
              Text(
                "Change Password",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<ChangePasswordProvider>(
        builder: (context, passwordProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenWidth * 0.08),
                  RichText(
                    text: TextSpan(
                      text: "Current Password",
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
                  SizedBox(height: screenWidth * 0.04),
                  PasswordField(
                    controller: currentPasswordController,
                    hintText: "Enter current password",
                    isPasswordVisible: isCurrentPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        isCurrentPasswordVisible = !isCurrentPasswordVisible;
                      });
                    },
                    fillColor: Color(0xFFFDFDFF),
                    borderColor: borderColor,
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Divider(
                    color: Color(0xFFEBEBEB),
                    thickness: 1,
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  RichText(
                    text: TextSpan(
                      text: "New Password",
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
                  SizedBox(height: screenWidth * 0.04),
                  PasswordField(
                    controller: newPasswordController,
                    hintText: "Enter new password",
                    isPasswordVisible: isNewPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        isNewPasswordVisible = !isNewPasswordVisible;
                      });
                    },
                    fillColor: Color(0xFFFDFDFF),
                    borderColor: borderColor,
                  ),
                  if (newPasswordController.text.length > 0 &&
                      newPasswordController.text.length < 8)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Password must be at least 8 characters long",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  SizedBox(height: screenWidth * 0.04),
                  RichText(
                    text: TextSpan(
                      text: "Confirm New Password",
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
                  SizedBox(height: screenWidth * 0.04),
                  PasswordField(
                    controller: confirmPasswordController,
                    hintText: "Repeat new password",
                    isPasswordVisible: isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    fillColor: Color(0xFFFDFDFF),
                    borderColor: borderColor,
                  ),
                  if (passwordProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        passwordProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  SizedBox(height: screenWidth * 0.5),
                  CustomButton(
                    text: isLoading ? 'Updating...' : "Update Password",
                    onPressed: isLoading
                        ? null // Disable button while loading
                        : () async {
                            if (newPasswordController.text.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Password must be at least 8 characters long"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("New passwords do not match"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isLoading = true; // Start loading
                            });

                            final success = await context
                                .read<ChangePasswordProvider>()
                                .changePassword(
                                  oldPassword: currentPasswordController.text,
                                  newPassword: newPasswordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                );

                            setState(() {
                              isLoading = false; // Stop loading
                            });

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Password updated successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
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
