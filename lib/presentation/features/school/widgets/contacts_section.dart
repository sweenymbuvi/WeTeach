import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/school/provider/view_school_provider.dart';

class ContactsSection extends StatelessWidget {
  const ContactsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final schoolProvider = Provider.of<ViewSchoolProvider>(context);
    final schoolDetails = schoolProvider.jobDetails?['school'];

    if (schoolProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (schoolDetails == null) {
      return const Center(child: Text("No school details available"));
    }

    // Extract contact details with fallback to 'N/A'
    final String primaryEmail = schoolDetails['primary_email'] ?? 'N/A';
    final String phoneNumber = schoolDetails['phone_number'] ?? 'N/A';
    final String website = schoolDetails['web_site']?.isNotEmpty == true
        ? schoolDetails['web_site']
        : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Email"),
        _contactItem(
            Assets.svg.email, primaryEmail), // Use the generated asset class
        _sectionTitle("Phone Number"),
        _contactItem(
            Assets.svg.phone, phoneNumber), // Use the generated asset class
        _sectionTitle("Website"),
        _contactItem(Assets.svg.web, website), // Use the generated asset class
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
              fontWeight: FontWeight.w500,
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
