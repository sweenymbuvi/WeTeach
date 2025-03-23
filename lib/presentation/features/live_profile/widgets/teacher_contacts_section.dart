import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';

class TeacherContactsSection extends StatelessWidget {
  const TeacherContactsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ProfileDetailsProvider
    final provider = Provider.of<ProfileDetailsProvider>(context);

    // Get the contact details from the provider
    final String primaryEmail =
        provider.userData?['primary_email'] ?? "No email available";
    final String phoneNumber =
        provider.userData?['phone_number'] ?? "No phone number available";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Email"),
        _contactItem(
            Assets.svg.email, primaryEmail), // Use the generated asset class
        _sectionTitle("Phone Number"),
        _contactItem(
            Assets.svg.phone, phoneNumber), // Use the generated asset class
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
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

  Widget _contactItem(String assetPath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SvgPicture.asset(assetPath, width: 20, height: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5C5C5C),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          _copyButton(text),
        ],
      ),
    );
  }

  Widget _copyButton(String text) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
      },
      child: SvgPicture.asset(
        Assets.svg.copy, // Use the generated asset class
        width: 24,
        height: 24,
      ),
    );
  }
}
