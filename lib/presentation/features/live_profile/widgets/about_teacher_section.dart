import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';

class AboutTeacherSection extends StatelessWidget {
  const AboutTeacherSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ProfileDetailsProvider
    final provider = Provider.of<ProfileDetailsProvider>(context);

    // Get the teacher bio from the provider
    final String teacherBio = provider.userData?['bio'] ?? "No bio available";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Teacher Bio"),
        _textContent(teacherBio),
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

  Widget _textContent(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF5C5C5C),
          height: 1.5,
        ),
      ),
    );
  }
}
