import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/gen/assets.gen.dart'; // Import the generated assets file
import 'package:we_teach/presentation/features/payment/screens/show_payment_screen.dart';
import 'package:we_teach/presentation/features/search/provider/job_search_provider.dart';
import 'package:we_teach/presentation/features/my_jobs/provider/my_jobs_provider.dart';
import 'package:we_teach/presentation/features/jobs/screens/job_details_screen.dart';
import 'package:we_teach/presentation/features/search/screens/search_bottom_sheet.dart';
import 'package:we_teach/presentation/shared/widgets/bottom_nav_bar.dart';

class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobSearchProvider>(context, listen: false).fetchJobs();
      Provider.of<MyJobsProvider>(context, listen: false).fetchViewedJobs();
    });

    // Listen to search input changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobSearchProvider = Provider.of<JobSearchProvider>(context);
    final myJobsProvider = Provider.of<MyJobsProvider>(context);

    // Filter jobs based on search query
    final jobs = jobSearchProvider.jobs.where((job) {
      final title = job['title']?.toLowerCase() ?? '';
      final county = job['county']?.toLowerCase() ?? '';
      final subCounty = job['sub_county']?.toLowerCase() ?? '';

      return title.contains(_searchQuery) ||
          county.contains(_searchQuery) ||
          subCounty.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Find any Job",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Search Bar with Blue Rectangle and Search Strings at the end
            SizedBox(
              height: 48,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for jobs",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF828282),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      Assets.svg.lens, // Use the generated asset class
                      width: 24,
                      height: 24,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return TeacherSearchBottomSheet(
                            scrollController: ScrollController(),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40, // Blue rectangle width
                        height: 40, // Blue rectangle height
                        decoration: BoxDecoration(
                          color: const Color(0xFF000EF8), // Blue color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.svg
                                .searchStrings, // Use the generated asset class
                            width: 24, // Search strings SVG width
                            height: 24, // Search strings SVG height
                          ),
                        ),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFF5F5F5),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: jobSearchProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : jobSearchProvider.errorMessage.isNotEmpty
                      ? Center(child: Text(jobSearchProvider.errorMessage))
                      : jobs.isEmpty
                          ? const Center(
                              child: Text(
                                "No jobs found.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                final job = jobs[index];
                                final isViewed = myJobsProvider.viewedJobs
                                    .any((j) => j['id'] == job['id']);
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: SizedBox(
                                        width: 40, // Constrain the width
                                        height: 40, // Constrain the height
                                        child: BlurredImage(
                                          imageUrl: job['image'],
                                          isBlurred: !isViewed,
                                        ),
                                      ),
                                      title: Text(
                                        job['title'],
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: job['creation_time'],
                                              style: GoogleFonts.inter(
                                                color: Color(0xFF000EF8),
                                              ),
                                            ),
                                            const TextSpan(
                                              text: " • ",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text:
                                                  "${job['county']}, ${job['sub_county']}",
                                              style: GoogleFonts.inter(
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16),
                                      onTap: () {
                                        // Check if the job is viewed
                                        if (isViewed) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JobDetailsScreen(
                                                        jobId: job['id'])),
                                          );
                                        } else {
                                          // Show payment bottom sheet
                                          PaymentBottomSheet.show(context,
                                              jobId: job['id']);
                                        }
                                      },
                                    ),
                                    const Divider(
                                      color: Color(0xFFF5F5F5),
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class BlurredImage extends StatelessWidget {
  final String? imageUrl;
  final bool isBlurred;

  const BlurredImage({
    Key? key,
    required this.imageUrl,
    required this.isBlurred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                ? NetworkImage(imageUrl!)
                : AssetImage("assets/images/app_icon.png") as ImageProvider,
          ),
          if (isBlurred)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
