import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/auth/profile/screens/profile_popup.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/services/secure_storage_service.dart'; // Import SecureStorageService

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  _ProfileCompleteScreenState createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    SecureStorageService().storeLastVisitedScreen('ProfileCompleteScreen');
    _fetchUserProfile(); // Fetch user profile data
  }

  Future<void> _fetchUserProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final userData = await authProvider.fetchUserData(); // Fetch user data
      setState(() {
        userProfile = userData; // Store the fetched profile data
      });
    } catch (error) {
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

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
                      backgroundImage: userProfile!['image'] != null &&
                              userProfile!['image'].isNotEmpty
                          ? NetworkImage(
                              userProfile!['image']) // Use full image URL
                          : AssetImage(Assets
                                  .images.man.path) // Use generated asset class
                              as ImageProvider,
                    ),

                    SizedBox(height: 16),
                    // Name and Profile Status
                    Text(
                      userProfile!['full_name'] ?? "User  Name",
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
                                Assets.svg
                                    .location, // Use the generated asset class
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${userProfile!['county']}\n${userProfile!['sub_county']}",
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
                                Assets
                                    .svg.time1, // Use the generated asset class
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${userProfile!['experience']} Years\nExperience",
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
                                Assets
                                    .svg.book1, // Use the generated asset class
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${userProfile!['qualifications']} H.S.\nSubjects",
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
