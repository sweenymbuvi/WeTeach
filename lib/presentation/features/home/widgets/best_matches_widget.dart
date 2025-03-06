import 'package:flutter/material.dart';
import 'package:we_teach/presentation/features/home/home_screen/screens/all_jobs_screen.dart';
import 'package:we_teach/presentation/features/home/widgets/job_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BestMatchesSection extends StatelessWidget {
  final List<Map<String, dynamic>> jobs;

  const BestMatchesSection({Key? key, required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Best Matches",
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // "See all" with icon next to it
              TextButton(
                onPressed: () {
                  // Navigate to the "See All" page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllJobsScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Text(
                      "See all",
                      style: TextStyle(
                        color: Color(0xFF000EF8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset(
                      'assets/svg/arrow-right.svg',
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // List of job cards
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return JobCard(
              jobId: job['id'], // Pass the jobId here
              jobTitle: job['jobTitle'],
              timePosted: job['timePosted'],
              location: job['location'],
              schoolName: job['schoolName'],
              //isSaved: job['isSaved'],
            );
          },
        ),
      ],
    );
  }
}
