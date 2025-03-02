import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStatusCard extends StatelessWidget {
  final bool isProfileLive;

  const ProfileStatusCard({Key? key, required this.isProfileLive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
            ? _buildLiveProfileContent()
            : _buildNotLiveProfileContent(),
      ),
    );
  }

  Widget _buildLiveProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/svg/profile-live.svg',
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
              children: const [
                Text(
                  "Visible Until",
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "2 Days 13 Hrs",
                  style: TextStyle(
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
              children: const [
                Text(
                  "Impressions",
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "3,435",
                  style: TextStyle(
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
      crossAxisAlignment:
          CrossAxisAlignment.start, // Change to start for vertical alignment
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
            'assets/svg/plane.svg',
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
