import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:we_teach/presentation/features/my_jobs/provider/my_jobs_provider.dart';
import 'package:we_teach/presentation/features/jobs/screens/job_details_screen.dart';
import 'package:we_teach/presentation/features/payment/screens/show_payment_screen.dart';

class JobCardTile extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String location;
  final String category;
  final String assetImage;
  final bool isSaved;
  final bool isBlurred;
  final int jobId;
  final bool showBookmarkIcon;

  const JobCardTile({
    super.key,
    required this.title,
    required this.timeAgo,
    required this.location,
    required this.category,
    required this.assetImage,
    required this.jobId,
    this.isSaved = false,
    this.isBlurred = false,
    this.showBookmarkIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final myJobsProvider = Provider.of<MyJobsProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        print("Job ID: $jobId");
        if (isBlurred) {
          // Show payment bottom sheet for blurred (unviewed) jobs
          PaymentBottomSheet.show(context, jobId: jobId);
        } else {
          // Navigate directly to job details for viewed jobs
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsScreen(jobId: jobId),
            ),
          );
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Stack(
                    children: [
                      _buildImage(assetImage),
                      if (isBlurred)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$timeAgo • $location",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showBookmarkIcon)
                  GestureDetector(
                    onTap: () {
                      if (isSaved && !myJobsProvider.isLoading) {
                        myJobsProvider.deleteSavedJob(jobId);
                      }
                    },
                    child: myJobsProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color:
                                isSaved ? const Color(0xFF000EF8) : Colors.grey,
                            size: 20,
                          ),
                  ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFF5F5F5),
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith("http")) {
      return Image.network(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/app_icon.png",
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }
  }
}
