import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/jobs/provider/view_job_provider.dart';

class AboutJobSection extends StatelessWidget {
  const AboutJobSection({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<ViewJobProvider>(context);
    final jobDetails = jobProvider.jobDetails;

    if (jobDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Extract and handle empty values
    final subjectsNeeded = jobDetails['teacher_requirements']
            ?.map<String>((req) => req['name'] as String)
            .toList() ??
        [];
    final additionalSkills =
        jobDetails['additional_requirements']?.trim().isEmpty ?? true
            ? 'N/A'
            : jobDetails['additional_requirements'];
    final dutiesAndResponsibilities =
        jobDetails['duties_and_responsibilities']?.trim().isEmpty ?? true
            ? 'N/A'
            : jobDetails['duties_and_responsibilities'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Subjects Needed'),
        subjectsNeeded.isEmpty
            ? _textContent('N/A')
            : _numberedList(subjectsNeeded),
        _sectionTitle('Additional Skills'),
        _textContent(additionalSkills),
        _sectionTitle('Duties and Responsibilities'),
        _textContent(dutiesAndResponsibilities),
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

  Widget _numberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index + 1}. ",
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

  Widget _textContent(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF5C5C5C),
        ),
      ),
    );
  }
}
