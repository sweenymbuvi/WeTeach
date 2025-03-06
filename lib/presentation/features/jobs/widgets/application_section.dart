import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/jobs/provider/view_job_provider.dart';

class ApplicationSection extends StatelessWidget {
  const ApplicationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<ViewJobProvider>(context);
    final jobDetails = jobProvider.jobDetails;

    if (jobDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Extract data
    final String deadlineRaw = jobDetails['deadline'] ?? '';
    final String howToApply = jobDetails['how_to_apply'] ?? 'N/A';

    // Format deadline date
    String formattedDeadline = 'N/A';
    if (deadlineRaw.isNotEmpty) {
      try {
        final DateTime deadlineDate = DateTime.parse(deadlineRaw);
        formattedDeadline = DateFormat('dd MMMM yyyy').format(deadlineDate);
      } catch (e) {
        formattedDeadline = 'Invalid date';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Application Deadline"),
        _textContent(formattedDeadline),
        _sectionTitle("How to Apply"),
        _textContent(howToApply),
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
