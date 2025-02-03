import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:we_teach/presentation/features/auth/profile/screens/add_qualifications.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/added_profile_pic.dart';
import 'package:we_teach/presentation/features/auth/profile/widgets/profile_button.dart';
import 'dart:io'; // Import for File

class AddProfilePhotoScreen extends StatelessWidget {
  const AddProfilePhotoScreen({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // If an image is selected, navigate to the ProfilePhotoAddedScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePhotoAddedScreen(
              imagePath: image.path), // Pass the image path
        ),
      );
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    // Initialize the ImagePicker
    final ImagePicker _picker = ImagePicker();

    // Open the camera and allow the user to take a photo
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    // Check if the user took a photo
    if (image != null) {
      // Navigate to the next screen and pass the image path
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePhotoAddedScreen(
            imagePath: image.path, // Pass the image path to the next screen
          ),
        ),
      );
    } else {
      // Handle the case where the user didn't take a photo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No photo was taken.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int currentPage = 1;

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
                    color: index <= currentPage
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/circle.svg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.scaleDown,
                      ),
                      Positioned(
                        top: screenHeight * 0.02,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFFDFDFF),
                          child: SvgPicture.asset(
                            'assets/svg/photo.svg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Passport size photo (Max size: 5mb)",
                    style: GoogleFonts.inter(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "No photo added",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Color(0xFF1F1F1F),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                ProfileButton(
                  onPressed: () {
                    _pickImage(context); // Call the method to pick an image
                  },
                  text: "Select from Gallery",
                  icon: SvgPicture.asset(
                    'assets/svg/image.svg',
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                  ),
                  isOutlined: true,
                ),
                SizedBox(height: screenHeight * 0.02),
                ProfileButton(
                  onPressed: () {
                    _takePhoto(context); // Call the method to take a new photo
                  },
                  text: "Take new Photo",
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
