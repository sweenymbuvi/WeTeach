import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_profile_pic.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_qualifications.dart';
import 'package:we_teach/presentation/features/auth/profile/widgets/profile_button.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'dart:io';
import 'package:we_teach/services/secure_storage_service.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart'; // Import for File

class ProfilePhotoAddedScreen extends StatefulWidget {
  final String imagePath; // Add a field to hold the image path

  const ProfilePhotoAddedScreen(
      {super.key, required this.imagePath}); // Update constructor

  @override
  State<ProfilePhotoAddedScreen> createState() =>
      _ProfilePhotoAddedScreenState();
}

class _ProfilePhotoAddedScreenState extends State<ProfilePhotoAddedScreen> {
  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    // SecureStorageService().storeLastVisitedScreen('ProfilePhotoAddedScreen');
    // Initialize auth state
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadTokens(); // Load tokens when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  width: screenWidth * 0.025,
                  height: screenWidth * 0.025,
                  decoration: BoxDecoration(
                    color: index <= 1 // Fill bubbles for index 0 and 1
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add a Profile Photo",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QualificationsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Skip",
                    style: GoogleFonts.inter(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.06),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFFDFDFF),
                    backgroundImage: FileImage(File(widget
                        .imagePath)), // Use FileImage to display the selected image
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/tick.svg',
                        height: 16,
                        width: 16,
                        fit: BoxFit.scaleDown,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        "Photo Added",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Color(0xFF1F1F1F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                CustomButton(
                  text: 'Proceed',
                  onPressed: () async {
                    // Retrieve user ID from secure storage
                    final secureStorageService = SecureStorageService();
                    final userId = await secureStorageService.getUserId();

                    // Check if userId is null
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("User  ID not found. Please log in again."),
                        ),
                      );
                      return;
                    }

                    // Call the AuthProvider to update the profile with the image
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    bool success = await authProvider.updateTeacherProfile(
                      userId: userId, // Use the retrieved user ID
                      image: widget.imagePath, // Pass the selected image path
                    );

                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QualificationsScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to update profile photo.')),
                      );
                    }
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                ProfileButton(
                  onPressed: () {
                    // Handle "Change Profile Photo" action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProfilePhotoScreen(),
                      ),
                    );
                  },
                  text: "Change Profile Photo",
                  icon: null,
                  isOutlined: false,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
