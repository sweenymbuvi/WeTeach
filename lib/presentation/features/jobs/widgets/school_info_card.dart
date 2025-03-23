import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/jobs/provider/view_job_provider.dart';
import 'package:we_teach/presentation/features/school/screens/view_school_screen.dart';

class SchoolInfoCard extends StatelessWidget {
  final int jobId;

  const SchoolInfoCard({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<ViewJobProvider>(context);
    final jobDetails = jobProvider.jobDetails;

    if (jobProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jobProvider.errorMessage != null) {
      return Center(child: Text(jobProvider.errorMessage!));
    }

    if (jobDetails == null || jobDetails["school"] == null) {
      return const Center(child: Text("No school information available."));
    }

    final school = jobDetails["school"];
    final schoolName = school["name"] ?? "Unknown School";
    final county = school["county"]?["name"] ?? "Unknown County";
    final subCounty = school["sub_county"]?["name"] ?? "Unknown Sub-County";
    final location = "$county, $subCounty";
    final imageUrl = school["image"] != null && school["image"].isNotEmpty
        ? "https://api.mwalimufinder.com${school["image"]}"
        : "assets/images/placeholder.png"; // Placeholder image

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewSchoolScreen(jobId: jobId),
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 280,
          maxWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFEBEBEB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  Assets.svg.ellipse, // Use the generated asset class
                  height: 48,
                  width: 48,
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: imageUrl.startsWith("http")
                      ? NetworkImage(imageUrl)
                      : AssetImage(imageUrl) as ImageProvider,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    schoolName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Posted ${_formatDate(jobDetails["creation_time"])}",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000EF8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              Assets.svg.arrow, // Use the generated asset class
              height: 16,
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null) return "Unknown date";
    DateTime parsedDate = DateTime.parse(dateTime);
    Duration difference = DateTime.now().difference(parsedDate);

    if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    } else {
      return "${difference.inMinutes} minutes ago";
    }
  }
}
