import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/home/home_screen/screens/home_screen.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';
import 'package:we_teach/presentation/features/live_profile/screens/public_payment_screen.dart';
import 'package:we_teach/presentation/features/live_profile/widgets/about_teacher_section.dart';
import 'package:we_teach/presentation/features/live_profile/widgets/tab_section.dart';
import 'package:we_teach/presentation/features/live_profile/widgets/teacher_contacts_section.dart';
import 'package:we_teach/presentation/features/live_profile/widgets/teacher_location_section.dart';
import 'package:we_teach/presentation/features/live_profile/widgets/teacher_qualifications_section.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

class TeacherLiveProfileScreen extends StatefulWidget {
  const TeacherLiveProfileScreen({super.key});

  @override
  State<TeacherLiveProfileScreen> createState() =>
      _TeacherLiveProfileScreenState();
}

class _TeacherLiveProfileScreenState extends State<TeacherLiveProfileScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen is initialized
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<ProfileDetailsProvider>(context, listen: false);
      provider.fetchUserData();
    });
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const AboutTeacherSection();
      case 1:
        return const TeacherQualificationsSection();
      case 2:
        return const TeacherLocationSection();
      case 3:
        return const TeacherContactsSection();
      default:
        return Container();
    }
  }

  Widget _buildLiveProfileContent(Map<String, dynamic>? profilePost) {
    // Calculate remaining time
    String remainingTime = "N/A";
    if (profilePost != null && profilePost['expiry_time'] != null) {
      final expiryTime = DateTime.parse(profilePost['expiry_time']);
      final now = DateTime.now();
      final difference = expiryTime.difference(now);

      if (difference.inDays > 0) {
        remainingTime =
            "${difference.inDays} Days ${(difference.inHours % 24)} Hrs";
      } else if (difference.inHours > 0) {
        remainingTime =
            "${difference.inHours} Hrs ${(difference.inMinutes % 60)} Mins";
      } else {
        remainingTime = "${difference.inMinutes} Mins";
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.svg.profileLive, // Use the generated asset class
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Your Profile is Live",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000EF8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visible Until",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    remainingTime,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 32,
                color: const Color(0xFF7D7D7D),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Impressions",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    "${profilePost?['views'] ?? 0}",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showPublicityPackageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return PublicityPackageBottomSheet(); // Ensure this widget is defined
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileDetailsProvider>(context);

    // Check if profile is live based on the fetched data
    final bool isProfileLive = provider.recentProfilePostIsActive;
    final profilePostDetails = provider.recentProfilePost;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Preview your Profile",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      children: [
                        SvgPicture.asset(
                          isProfileLive
                              ? Assets.svg
                                  .blueCircle // Use the generated asset class
                              : Assets.svg.ellipse,
                          width: 120,
                          height: 120,
                        ),
                        if (isProfileLive)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: SvgPicture.asset(
                              Assets
                                  .svg.blueDot, // Use the generated asset class
                              width: 12,
                              height: 12,
                            ),
                          ),
                      ],
                    ),
                    ClipOval(
                      child: Image(
                        image: provider.userData?['image'] != null
                            ? NetworkImage(provider.userData!['image'])
                            : AssetImage(Assets.images.man.path)
                                as ImageProvider,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                provider.userData?['full_name'] ?? "John Doe",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${provider.userData?['county'] ?? "Nairobi"}, ${provider.userData?['sub_county'] ?? "Sub County Name"}",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Open to opportunities",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF000EF8),
                ),
              ),
              if (isProfileLive) _buildLiveProfileContent(profilePostDetails),
              const SizedBox(height: 16),
              TeacherProfileTabSection(
                onTabChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTabContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isProfileLive
            ? ElevatedButton(
                onPressed: () async {
                  // Call the delete method from the provider
                  await provider.deleteTeacherProfilePost();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Profile taken offline successfully!",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: const Color(0xFF000EF8),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Navigate to HomeScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false, // This clears the navigation stack
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFAFAFA),
                  foregroundColor: const Color(0xFF000EF8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: const Color(0xFFFAFAFA)),
                  ),
                ).copyWith(elevation: MaterialStateProperty.all(0)),
                child: Text(
                  "Take Profile Offline",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF000EF8),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              )
            : CustomButton(
                text: "Take Profile Live",
                onPressed: () {
                  showPublicityPackageBottomSheet(context);
                },
              ),
      ),
    );
  }
}
