import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/my_jobs/provider/my_jobs_provider.dart';
import 'package:we_teach/presentation/features/my_jobs/widgets/job_card_tile.dart';

class SavedJobsList extends StatefulWidget {
  final String searchQuery; // Accept search query

  const SavedJobsList({super.key, required this.searchQuery});

  @override
  State<SavedJobsList> createState() => _SavedJobsListState();
}

class _SavedJobsListState extends State<SavedJobsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MyJobsProvider>(context, listen: false);
      provider.fetchSavedJobs();
      provider.fetchViewedJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyJobsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading saved jobs',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(provider.errorMessage ?? 'Unknown error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchSavedJobs(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (provider.savedJobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No saved jobs yet',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jobs you save will appear here',
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Filter jobs based on search query
        List<Map<String, dynamic>> filteredJobs =
            provider.savedJobs.where((job) {
          return job['job_title']
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase());
        }).toList();

        // Create a set of viewed job IDs for quick lookup
        Set<int> viewedJobIds =
            provider.viewedJobs.map((job) => job['id'] as int).toSet();

        Map<String, List<Map<String, dynamic>>> groupedJobs =
            _groupJobsByTimeframe(filteredJobs);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String timeframe in groupedJobs.keys)
                if (groupedJobs[timeframe]?.isNotEmpty ?? false) ...[
                  _buildSectionTitle(timeframe),
                  ...groupedJobs[timeframe]!.map((job) {
                    return JobCardTile(
                      title: job['job_title'] ?? 'Job Title',
                      timeAgo: "Saved ${job['saved_time'] ?? ''}",
                      location:
                          '${job['sub_county'] ?? ''}, ${job['county'] ?? ''}',
                      category: 'Education',
                      assetImage:
                          job['school_image'] ?? 'assets/images/app_icon.png',
                      jobId: job['id'],
                      isSaved: true,
                      isBlurred: !viewedJobIds.contains(job['id']),
                    );
                  }).toList(),
                ],
            ],
          ),
        );
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupJobsByTimeframe(
      List<Map<String, dynamic>> jobs) {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'Today': [],
      'This Month': [],
      'Earlier': [],
    };

    for (var job in jobs) {
      String savedTime = job['saved_time'] ?? '';

      if (savedTime.contains('ago') &&
          (savedTime.contains('seconds') ||
              savedTime.contains('minutes') ||
              savedTime.contains('hours') ||
              savedTime.contains('a day'))) {
        grouped['Today']!.add(job);
      } else if (savedTime.contains('days') ||
          savedTime.contains('a week') ||
          savedTime.contains('weeks')) {
        grouped['This Month']!.add(job);
      } else {
        grouped['Earlier']!.add(job);
      }
    }

    return grouped;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
