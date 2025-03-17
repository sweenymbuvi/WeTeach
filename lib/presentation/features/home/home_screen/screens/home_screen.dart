import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/home/widgets/best_matches_widget.dart';
import 'package:we_teach/presentation/features/home/widgets/top_section_widget.dart';
import 'package:we_teach/presentation/features/notifications/screens/notification_screen.dart';
import 'package:we_teach/presentation/shared/widgets/bottom_nav_bar.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/user_details_provider.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/job_details_provider.dart';
import 'package:we_teach/presentation/features/notifications/provider/notifications_provider.dart';
import 'package:we_teach/services/secure_storage_service.dart';
import 'package:we_teach/services/local_notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex =
      0; // Track the selected index for the bottom navigation bar
  final SecureStorageService _secureStorageService = SecureStorageService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize notifications service first if not already done elsewhere
    await LocalNotificationService.initialize();

    // Set up notification tap handler to navigate to the notifications screen
    LocalNotificationService.onNotificationTap = () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
      );
    };

    // Store the last visited screen
    await _secureStorageService.storeLastVisitedScreen('HomeScreen');

    // Fetch data
    Future.microtask(() async {
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      final jobDetailsProvider =
          Provider.of<JobDetailsProvider>(context, listen: false);
      final notificationsProvider =
          Provider.of<NotificationsProvider>(context, listen: false);

      // Fetch user and job details
      userDetailsProvider.fetchUserDetails();
      jobDetailsProvider.fetchJobDetails();

      // Fetch notifications first
      await notificationsProvider.fetchNotifications();

      // Then check for new notifications to display
      await notificationsProvider.checkAndShowNewNotifications();

      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the notification tap handler when this screen is disposed
    LocalNotificationService.onNotificationTap = null;
    super.dispose();
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

          // Navigate to NotificationsScreen if notifications tab is selected
          if (index == 3) {
            // Assuming notifications tab is at index 3
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()),
            );
          }
        },
      ),
    );
  }
}
