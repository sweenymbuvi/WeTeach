import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/auth/profile/screens/add_qualifications.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/added_profile_pic.dart';
import 'package:we_teach/presentation/features/auth/profile/widgets/profile_button.dart';
import 'package:we_teach/services/secure_storage_service.dart';
import 'package:we_teach/utils/image_utils.dart'; // Import the ImageUtils class

class AddProfilePhotoScreen extends StatefulWidget {
  const AddProfilePhotoScreen({super.key});

  @override
  State<AddProfilePhotoScreen> createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    SecureStorageService().storeLastVisitedScreen('AddProfilePhotoScreen');
  }

  Future<void> _pickImage(BuildContext context) async {
    final image = await ImageUtils.pickImage();

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePhotoAddedScreen(imagePath: image.path),
        ),
      );
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final image = await ImageUtils.takePhoto();

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePhotoAddedScreen(imagePath: image.path),
        ),
      );
    } else {
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
                        Assets.svg.circle, // Use the generated asset class
                        height: 100,
                        width: 100,
                        fit: BoxFit.scaleDown,
                      ),
                      Positioned(
                        top: screenHeight * 0.02,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFFDFDFF),
                          child: SvgPicture.asset(
                            Assets.svg.photo, // Use the generated asset class
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
                      color: const Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "No photo added",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF1F1F1F),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                ProfileButton(
                  onPressed: () {
                    _pickImage(context);
                  },
                  text: "Select from Gallery",
                  icon: SvgPicture.asset(
                    Assets.svg.image, // Use the generated asset class
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                  ),
                  isOutlined: true,
                ),
                SizedBox(height: screenHeight * 0.02),
                ProfileButton(
                  onPressed: () {
                    _takePhoto(context);
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
