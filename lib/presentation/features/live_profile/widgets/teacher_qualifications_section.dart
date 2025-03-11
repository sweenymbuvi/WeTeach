import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';

class TeacherQualificationsSection extends StatelessWidget {
  const TeacherQualificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ProfileDetailsProvider
    final provider = Provider.of<ProfileDetailsProvider>(context);

    // Get the qualifications from the provider
    final List<dynamic> qualifications =
        provider.userData?['qualifications'] ?? [];

    // Convert qualifications to a list of formatted strings
    final List<String> qualificationNames = qualifications
        .whereType<Map<String, dynamic>>() // Ensure each item is a Map
        .map<String>((qualification) =>
            qualification['name'] as String? ?? "Unknown Qualification")
        .toList();

    // If there are no qualifications, provide a default message
    if (qualificationNames.isEmpty) {
      qualificationNames.add("No Qualifications Available");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Teaching Subjects'),
        _numberedList(qualificationNames),
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

  Widget _numberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              Expanded(
                child: Text(
                  items[index],
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
      }),
    );
  }
}
