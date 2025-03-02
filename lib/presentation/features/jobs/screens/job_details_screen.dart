import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/jobs/provider/view_job_provider.dart';
import 'package:we_teach/presentation/features/jobs/widgets/about_job.dart';
import 'package:we_teach/presentation/features/jobs/widgets/application_section.dart';
import 'package:we_teach/presentation/features/jobs/widgets/contacts_section.dart';
import 'package:we_teach/presentation/features/jobs/widgets/job_details_tab.dart';
import 'package:we_teach/presentation/features/jobs/widgets/qualification_section.dart';
import 'package:we_teach/presentation/features/jobs/widgets/school_info_card.dart';

class JobDetailsScreen extends StatefulWidget {
  final int jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ViewJobProvider>(context, listen: false)
        .fetchJobDetails(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Explore Opportunity',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000EF8),
          ),
        ),
      ),
      body: Consumer<ViewJobProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.jobDetails == null) {
            return const Center(child: Text("No job details available"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pass jobId to SchoolInfoCard
                SchoolInfoCard(jobId: widget.jobId),
                const SizedBox(height: 16),
                JobDetailsTabSection(
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTabContent(provider.jobDetails!),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> jobDetails) {
    switch (_selectedTabIndex) {
      case 0:
        return AboutJobSection();
      case 1:
        return QualificationsSection();
      case 2:
        return ApplicationSection();
      case 3:
        return ContactsSection();
      default:
        return Container();
    }
  }

  Widget _buildBottomButtons() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                fixedSize: const Size(120, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFFF5F5F5)),
              ),
              child: Text(
                'Saved',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000EF8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                fixedSize: const Size(120, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFFF5F5F5)),
              ),
              child: Text(
                'Call School',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000EF8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
