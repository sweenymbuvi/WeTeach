import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/home/widgets/best_matches_widget.dart';
import 'package:we_teach/presentation/features/home/widgets/top_section_widget.dart';
import 'package:we_teach/presentation/shared/widgets/bottom_nav_bar.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/user_details_provider.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/job_details_provider.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex =
      0; // Track the selected index for the bottom navigation bar
  final SecureStorageService _secureStorageService =
      SecureStorageService(); // Add this line

  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    _secureStorageService.storeLastVisitedScreen('HomeScreen'); // Add this line
    // Fetch user details and job details when the HomeScreen is initialized
    Future.microtask(() {
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      final jobDetailsProvider =
          Provider.of<JobDetailsProvider>(context, listen: false);

      userDetailsProvider.fetchUserDetails();
      jobDetailsProvider.fetchJobDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    final jobDetailsProvider = Provider.of<JobDetailsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white, // Ensure background is white
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopSection(), // Display TopSection
            jobDetailsProvider.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
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
                        ? BestMatchesSection(
                            jobs: jobDetailsProvider.jobsData!
                                .map((job) => {
                                      'id': job['id'], // Pass jobId here
                                      'jobTitle':
                                          job['title'] ?? 'Unnamed Position',
                                      'timePosted':
                                          job['creation_time'] ?? 'Unknown',
                                      'location':
                                          '${job['sub_county'] ?? ''}, ${job['county'] ?? 'Unknown'}',
                                      'schoolName': job['school_name'] ??
                                          'Unknown School',
                                      'isSaved':
                                          false, // Default value since API doesn't provide this
                                    })
                                .toList(),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('No job listings available.'),
                            ),
                          ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
