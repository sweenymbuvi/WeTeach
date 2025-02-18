import 'dart:convert';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_profile_pic.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart'; // Add this import

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  String? selectedLevel;
  final List<String> institutionLevels = [
    'ECDE',
    'Primary School',
    'High School',
    'Junior Secondary',
  ];
  final int _currentPage = 0;
  final Color borderColor = Color(0x00476be8).withOpacity(0.11);

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  String _completePhoneNumber = '';

  Widget buildSectionTitle(String title) {
    return Material(
      color: const Color(0xFFFDFDFF),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Text(
              '*',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    Widget? prefixIcon,
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF828282),
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: prefixIcon,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFFDFDFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.04);
    final authProvider =
        Provider.of<AuthProvider>(context); // Access the auth provider

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            pinned: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(
                  right: screenWidth * 0.04,
                  top: screenHeight * 0.02,
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      width: screenWidth * 0.025,
                      height: screenWidth * 0.025,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFFAC00E6)
                            : const Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Let\'s get to know you',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      buildSectionTitle('Full Name'),
                      SizedBox(height: screenHeight * 0.02),
                      buildTextField(
                        hintText: 'Enter name',
                        prefixIcon: SvgPicture.asset(
                          'assets/svg/user.svg',
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                        controller: fullNameController,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Phone Number'),
                      SizedBox(height: screenHeight * 0.02),
                      IntlPhoneField(
                        controller: phoneNumberController,
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
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Profile Description'),
                      SizedBox(height: screenHeight * 0.02),
                      buildTextField(
                        hintText: 'Tell others about yourself',
                        maxLines: 5,
                        controller: bioController,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Teaching Experience'),
                      SizedBox(height: screenHeight * 0.02),
                      buildTextField(
                        hintText: 'Enter number of years',
                        controller: experienceController,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Institution Level'),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        value: selectedLevel,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLevel = newValue;
                          });
                        },
                        items: institutionLevels
                            .map((level) => DropdownMenuItem<String>(
                                  value: level,
                                  child:
                                      Text(level, style: GoogleFonts.inter()),
                                ))
                            .toList(),
                        hint: Text(
                          'Select institution level',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF828282),
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/svg/school.svg',
                              height: screenWidth * 0.06,
                              width: screenWidth * 0.06,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFDFDFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: Column(
                          children: [
                            CustomButton(
                              text: "Continue",
                              onPressed: () async {
                                // Validate that the phone number is not empty
                                if (_completePhoneNumber.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Please enter a valid phone number."),
                                    ),
                                  );
                                  return;
                                }

                                // Call the createTeacherProfile method
                                final success =
                                    await authProvider.createTeacherProfile(
                                  userId: authProvider
                                      .userId!, // User ID from "Set Password"
                                  fullName: fullNameController.text,
                                  phoneNumber:
                                      _completePhoneNumber, // Use the complete phone number
                                  bio: bioController.text,
                                  institutionLevel: institutionLevels
                                          .indexOf(selectedLevel!) +
                                      1,
                                  experience:
                                      int.tryParse(experienceController.text) ??
                                          0,
                                );

                                if (success) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddProfilePhotoScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Failed to create teacher profile."),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
