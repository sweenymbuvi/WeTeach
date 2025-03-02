import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/school/provider/view_school_provider.dart';

class AboutSchoolSection extends StatelessWidget {
  const AboutSchoolSection({super.key});

  @override
  Widget build(BuildContext context) {
    final schoolProvider = Provider.of<ViewSchoolProvider>(context);
    final jobDetails = schoolProvider.jobDetails;

    if (schoolProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (schoolProvider.errorMessage != null) {
      return Center(child: Text(schoolProvider.errorMessage!));
    }
    if (jobDetails == null || jobDetails['school'] == null) {
      return _textContent("School details not available");
    }

    final schoolDetails = jobDetails['school'];
    final schoolBio = schoolDetails['about']?.trim().isEmpty ?? true
        ? 'Not Available'
        : schoolDetails['about'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("School Bio"),
        _textContent(schoolBio),
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
