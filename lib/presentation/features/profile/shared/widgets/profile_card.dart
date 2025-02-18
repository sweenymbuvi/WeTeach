import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/profile/manage_profile/provider/manage_profile_provider.dart';
import 'package:we_teach/presentation/features/profile/personal_info/screens/personal_info_screen.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isVisible = true; // Visibility state

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userProfileProvider =
          Provider.of<UserProfileProvider>(context, listen: false);
      if (userProfileProvider.userData == null) {
        userProfileProvider.fetchUserProfile();
      }
    });
  }

  void _hideProfileCard() {
    setState(() {
      _isVisible = false; // Hide the profile card
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    // If _isVisible is false, return an empty container (removes ProfileCard)
    if (!_isVisible) return SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        // Navigate to PersonalInfoScreen and wait for result
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
        );

        // Check if profile was updated successfully
        if (result == true) {
          _hideProfileCard(); // Hide profile card on success
        }
      },
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 280,
          maxWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFEBEBEB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/ellipse.svg",
                  height: 48,
                  width: 48,
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      userProfileProvider.userData?['image'] != null
                          ? NetworkImage(userProfileProvider.userData!['image'])
                          : const AssetImage("assets/images/man.png")
                              as ImageProvider,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userProfileProvider.userData?['full_name'] ??
                        'Unknown User',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: userProfileProvider
                                  .userData?['institution_level_name'] ??
                              'Unknown Institution Level',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        TextSpan(
                          text: " Teacher",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        TextSpan(
                          text: " · ",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        TextSpan(
                          text: "Joined " +
                              (userProfileProvider.userData?['joined_date'] ??
                                  'recently'),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF7D7D7D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              "assets/svg/arrow.svg",
              height: 16,
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
