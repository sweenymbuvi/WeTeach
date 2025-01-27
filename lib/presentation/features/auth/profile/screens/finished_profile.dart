import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/profile_popup.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class ProfileCompleteScreen extends StatelessWidget {
  const ProfileCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/images/man.png'), // Replace with actual image
                    ),
                    SizedBox(height: 16),
                    // Name and Profile Status
                    Text(
                      "Simon Ndung'u",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Profile Complete",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Information Cards (Icons in a row)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Location
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFFAFAFA),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/location.svg',
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Nairobi\nWestlands",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                        // Vertical line after Location
                        Container(
                          width: 1,
                          height: 80,
                          color: Color(0xFFEBEBEB),
                        ),
                        // Experience
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFFAFAFA),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/time1.svg',
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "3 Years\nExperience",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                        // Vertical line after Experience
                        Container(
                          width: 1,
                          height: 80,
                          color: Color(0xFFEBEBEB),
                        ),
                        // Subjects
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFFAFAFA),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/book1.svg',
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "3 H.S.\nSubjects",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // "Explore endless opportunities" text above the button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Explore endless opportunities from diverse institutions for your next job",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7D7D7D),
              ),
            ),
          ),
          SizedBox(height: 2), // Space between text and button
          // Adjusted padding to move the button up slightly with space at the bottom
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
            child: CustomButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePopup()));
              },
              text: "Explore Opportunities",
            ),
          ),
        ],
      ),
    );
  }
}
