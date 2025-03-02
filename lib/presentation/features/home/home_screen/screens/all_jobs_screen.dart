// Updated AllJobsScreen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/home/widgets/job_card.dart';
import 'package:we_teach/presentation/features/home/widgets/top_section_widget.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/job_details_provider.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({Key? key}) : super(key: key);

  @override
  _AllJobsScreenState createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final jobDetailsProvider =
          Provider.of<JobDetailsProvider>(context, listen: false);

      if (jobDetailsProvider.jobsData == null) {
        jobDetailsProvider.fetchJobDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<JobDetailsProvider>(
        builder: (context, jobDetailsProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const TopSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "All Best Matches",
                        style: TextStyle(
                          color: Color(0xFF1F1F1F),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                jobDetailsProvider.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : jobDetailsProvider.errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Error: ${jobDetailsProvider.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                        : jobDetailsProvider.jobsData != null &&
                                jobDetailsProvider.jobsData!.isNotEmpty
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: jobDetailsProvider.jobsData!.length,
                                itemBuilder: (context, index) {
                                  final jobData =
                                      jobDetailsProvider.jobsData![index];
                                  return JobCard(
                                    jobId: jobData['id'],
                                    jobTitle:
                                        jobData['title'] ?? 'Unnamed Position',
                                    timePosted:
                                        jobData['creation_time'] ?? 'Unknown',
                                    location:
                                        '${jobData['sub_county'] ?? ''}, ${jobData['county'] ?? 'Unknown'}',
                                    schoolName: jobData['school_name'] ??
                                        'Unknown School',
                                    isSaved: false,
                                  );
                                },
                              )
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text('No job listings available.'),
                                ),
                              ),
              ],
            ),
          );
        },
      ),
    );
  }
}
