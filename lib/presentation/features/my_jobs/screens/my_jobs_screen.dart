import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/my_jobs/widgets/my_jobs_header.dart';
import 'package:we_teach/presentation/features/my_jobs/widgets/viewed_jobs_list.dart';
import 'package:we_teach/presentation/features/my_jobs/widgets/saved_jobs_list.dart';
import 'package:we_teach/presentation/shared/widgets/bottom_nav_bar.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  _MyJobsScreenState createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  int _currentIndex = 1; // Set the current index to My Jobs
  String _searchQuery = ''; // Store the search query

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query; // Update the search query
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyJobsHeader(
            onSearchChanged: _onSearchChanged), // Pass the callback
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Styled TabBar
            TabBar(
              indicatorColor: const Color(0xFF000EF8),
              indicatorWeight: 3,
              labelColor: const Color(0xFF000EF8),
              unselectedLabelColor: const Color(0xFF1F1F1F),
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              dividerColor: const Color(0xFFF5F5F5),
              tabs: const [
                Tab(text: "Viewed Jobs"),
                Tab(text: "Saved Jobs"),
              ],
            ),
            // Expanded to take remaining space
            Expanded(
              child: TabBarView(
                children: [
                  ViewedJobsList(
                      searchQuery: _searchQuery), // Pass the search query
                  SavedJobsList(
                      searchQuery: _searchQuery), // Pass the search query
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the selected index
            });
          },
        ),
      ),
    );
  }
}
