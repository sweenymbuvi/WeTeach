import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';
import 'package:we_teach/presentation/features/live_profile/screens/teacher_profile_screen.dart';

class ProfileStatusCard extends StatefulWidget {
  final BuildContext parentContext;

  const ProfileStatusCard({
    Key? key,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<ProfileStatusCard> createState() => _ProfileStatusCardState();
}

class _ProfileStatusCardState extends State<ProfileStatusCard> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    Future.delayed(Duration.zero, () {
      final provider =
          Provider.of<ProfileDetailsProvider>(context, listen: false);
      provider.fetchUserData();
    });
  }

  String _getRemainingTime(String? expiryTimeStr) {
    if (expiryTimeStr == null)
      return "2 Days 13 Hrs"; // Default value to match UI

    try {
      final expiryTime = DateTime.parse(expiryTimeStr);
      final now = DateTime.now();
      final difference = expiryTime.difference(now);

      if (difference.inDays > 0) {
        return "${difference.inDays} Days ${(difference.inHours % 24)} Hrs";
      } else if (difference.inHours > 0) {
        return "${difference.inHours} Hrs ${(difference.inMinutes % 60)} Mins";
      } else {
        return "${difference.inMinutes} Mins";
      }
    } catch (e) {
      return "2 Days 13 Hrs"; // Default value to match UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailsProvider>(
      builder: (context, provider, child) {
        // Get profile status from provider
        final bool isProfileLive = provider.recentProfilePostIsActive;
        final profilePost = provider.recentProfilePost;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              widget.parentContext,
              MaterialPageRoute(
                builder: (context) => TeacherLiveProfileScreen(),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFEDEEFF),
                    Color(0xFFF6ECFF),
                    Color(0xFFFAEAFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isProfileLive
                  ? _buildLiveProfileContent(profilePost)
                  : _buildNotLiveProfileContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiveProfileContent(Map<String, dynamic>? profilePost) {
    final String remainingTime = _getRemainingTime(profilePost?['expiry_time']);
    final impressions =
        profilePost?['views'] ?? 3435; // Default value to match UI

    // Format impressions with commas
    final String formattedImpressions = impressions.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return Column(
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
            const Text(
              "Your Profile is Live",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF000EF8),
                fontFamily: 'Inter',
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
                const Text(
                  "Visible Until",
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  remainingTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    fontFamily: 'Inter',
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
                const Text(
                  "Impressions",
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  formattedImpressions,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotLiveProfileContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SvgPicture.asset(
            Assets.svg.plane, // Use the generated asset class
            height: 40,
            width: 40,
            colorFilter: const ColorFilter.mode(
              Color(0xFF000EF8),
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Let Schools Know You are Available",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Publicize your profile to let schools know that you are available for work.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 129,
                child: ElevatedButton(
                  onPressed: () {
                    // Post profile action
                    Navigator.push(
                      widget.parentContext, // Use the passed context here
                      MaterialPageRoute(
                        builder: (context) => TeacherLiveProfileScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000EF8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    "Post your profile",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
