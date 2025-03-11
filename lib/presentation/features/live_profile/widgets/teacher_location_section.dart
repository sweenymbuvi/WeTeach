import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';

class TeacherLocationSection extends StatelessWidget {
  const TeacherLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ProfileDetailsProvider
    final provider = Provider.of<ProfileDetailsProvider>(context);

    // Get the county and sub-county from the provider
    final String county = provider.userData?['county'] ?? "Not Available";
    final String subCounty =
        provider.userData?['sub_county'] ?? "Not Available";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Teacher's Location"),
        _locationItem("assets/svg/location.svg", "County: $county"),
        _locationItem("assets/svg/location.svg", "Sub-county: $subCounty"),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFF5F5F5),
          thickness: 1,
        ),
      ],
    );
  }

  Widget _locationItem(String assetPath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SvgPicture.asset(assetPath,
              width: 20, height: 20, color: const Color(0xFF000EF8)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
