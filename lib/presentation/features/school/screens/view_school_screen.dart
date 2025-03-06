import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_teach/constants/constants.dart';
import 'package:we_teach/presentation/features/my_jobs/screens/my_jobs_screen.dart';
import 'package:we_teach/presentation/features/school/provider/view_school_provider.dart';
import 'package:we_teach/presentation/features/school/widgets/about_school_section.dart';
import 'package:we_teach/presentation/features/school/widgets/contacts_section.dart';
import 'package:we_teach/presentation/features/school/widgets/gallery_section.dart';
import 'package:we_teach/presentation/features/school/widgets/location_section.dart';
import 'package:we_teach/presentation/features/school/widgets/school_tab.dart';

class ViewSchoolScreen extends StatefulWidget {
  final int jobId;

  const ViewSchoolScreen({super.key, required this.jobId});

  @override
  State<ViewSchoolScreen> createState() => _ViewSchoolScreenState();
}

class _ViewSchoolScreenState extends State<ViewSchoolScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ViewSchoolProvider>(context, listen: false)
          .fetchSchoolDetails(widget.jobId);
    });
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const AboutSchoolSection();
      case 1:
        return const ContactsSection();
      case 2:
        return const LocationSection();
      case 3:
        return const GallerySection();
      default:
        return Container();
    }
  }

  void onShareClicked() {
    Share.share(
      "Check out this awesome app!\nDownload it from the Play Store: ${Constants.playStoreLink}",
    );
  }

  // Updated method to fix phone call issue
  void _callSchool(String phoneNumber) async {
    // Format the phone number correctly (ensure it has no spaces)
    String formattedNumber = phoneNumber.replaceAll(' ', '');

    // Try using the tel: URI scheme first
    final Uri phoneUri = Uri.parse('tel:$formattedNumber');

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Fallback to the older method if the first approach fails
        if (await canLaunch('tel:$formattedNumber')) {
          await launch('tel:$formattedNumber');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not launch phone dialer")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error making call: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final schoolProvider = Provider.of<ViewSchoolProvider>(context);
    final jobDetails = schoolProvider.jobDetails;

    if (schoolProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (schoolProvider.errorMessage != null) {
      return Scaffold(body: Center(child: Text(schoolProvider.errorMessage!)));
    }

    if (jobDetails == null || jobDetails["school"] == null) {
      return const Scaffold(
          body: Center(child: Text("No school information available.")));
    }

    final school = jobDetails["school"];
    final schoolName = school["name"] ?? "Unknown School";
    final county = school["county"]?["name"] ?? "Unknown County";
    final subCounty = school["sub_county"]?["name"] ?? "Unknown Sub-County";
    final location = "$county, $subCounty";
    final imageUrl = school["image"] != null && school["image"].isNotEmpty
        ? "https://api.mwalimufinder.com${school["image"]}"
        : "assets/images/placeholder.png";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Explore Institution",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1E1E),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/svg/share_school.svg"),
            onPressed: onShareClicked,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/ellipse.svg",
                        width: 120, height: 120),
                    ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 115,
                        height: 115,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 115,
                            height: 115,
                            color: Colors.grey[200],
                            child: const Icon(Icons.school, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                schoolName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              const SizedBox(height: 16),
              SchoolTabSection(
                onTabChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTabContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyJobsScreen(),
                    ),
                  );
                },
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
                  'View Jobs',
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
                onPressed: () {
                  final phoneNumber = schoolProvider.jobDetails?['school']
                          ['phone_number'] ??
                      'N/A';
                  if (phoneNumber != 'N/A') {
                    _callSchool(phoneNumber);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Phone number not available")),
                    );
                  }
                },
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
      ),
    );
  }
}
