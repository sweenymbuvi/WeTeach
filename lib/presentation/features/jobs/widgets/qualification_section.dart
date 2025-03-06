import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/jobs/provider/view_job_provider.dart';

class QualificationsSection extends StatelessWidget {
  const QualificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<ViewJobProvider>(context);
    final jobDetails = jobProvider.jobDetails;

    if (jobDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Extract and handle empty values
    final minimumRequirements =
        jobDetails['minimum_requirements']?.trim().isEmpty ?? true
            ? 'N/A'
            : jobDetails['minimum_requirements'];

    final additionalRequirements =
        jobDetails['additional_requirements']?.trim().isEmpty ?? true
            ? 'N/A'
            : jobDetails['additional_requirements'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Minimum Requirements'),
        _bulletList([minimumRequirements]),
        _sectionTitle('Added Advantage'),
        _bulletList([additionalRequirements]),
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

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5C5C5C),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF5C5C5C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
