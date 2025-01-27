import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this package to your pubspec.yaml
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/widgets/profile_button.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class ProfilePopup extends StatefulWidget {
  const ProfilePopup({super.key});

  @override
  _ProfilePopupState createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  @override
  void initState() {
    super.initState();
    // Show the popup automatically when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopupDialog();
    });
  }

  void _showPopupDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the popup by tapping outside
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top part with background color filling the entire section
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA), // Background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'assets/images/pana.png',
                        height: 100,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/svg/profile.svg',
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom part with white background
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Help Schools Discover You',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000EF8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Schools check live teacher profiles looking for a match for a new position. Go live, let schools look for you.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6D6D6D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Custom Go Live Button
                  CustomButton(
                    text: 'Go Live',
                    onPressed: () {
                      // Add your action here
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                  SizedBox(height: 10),

                  // Profile Button
                  ProfileButton(
                    text: 'Preview your Profile',
                    onPressed: () {
                      // Add your action here
                      Navigator.pop(context); // Close the dialog
                    },
                    isOutlined: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(color: Colors.white), // Blank page background
    );
  }
}
