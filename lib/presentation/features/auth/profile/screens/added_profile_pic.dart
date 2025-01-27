import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_qualifications.dart';
import 'package:we_teach/presentation/features/auth/profile/widgets/profile_button.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class ProfilePhotoAddedScreen extends StatelessWidget {
  const ProfilePhotoAddedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can manage _currentPage in a StatefulWidget or with a PageController
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
                    color:
                        index <= currentPage // Fill bubbles for index 0 and 1
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
      backgroundColor: Colors.white, // Ensure the background is white
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                screenWidth * 0.04), // Adjust padding based on screen width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Skip Button in One Row
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
                    // Handle skip logic here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QualificationsScreen()));
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
            SizedBox(height: screenHeight * 0.06), // Adjusted spacing
            SizedBox(height: screenHeight * 0.06), // Adjusted spacing

            Center(
              child: Column(
                children: [
                  // Circle Avatar for Profile Photo
                  CircleAvatar(
                    radius: 40, // Keep original size
                    backgroundColor: Color(0xFFFDFDFF),
                    backgroundImage: AssetImage(
                        'assets/images/man.png'), // Replace with your image path
                  ),
                  SizedBox(height: screenHeight * 0.01), // Adjusted spacing

                  // Row with SVG Icon and Text
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/tick.svg', // Replace with your SVG asset path
                        height: 16,
                        width: 16,
                        fit: BoxFit.scaleDown,
                      ),
                      SizedBox(
                          width: screenWidth *
                              0.02), // Spacing between icon and text
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QualificationsScreen()));
                    }),
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                ProfileButton(
                  onPressed: () {
                    // Handle "Change Profile Photo" action here
                  },
                  text: "Change Profile Photo",
                  icon: null, // No icon for this button
                  isOutlined: false,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04), // Adjusted bottom spacing
          ],
        ),
      ),
    );
  }
}
