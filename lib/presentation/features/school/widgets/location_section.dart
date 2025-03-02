import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_teach/presentation/features/school/provider/view_school_provider.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final schoolProvider = Provider.of<ViewSchoolProvider>(context);
    final jobDetails = schoolProvider.jobDetails;

    if (schoolProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (schoolProvider.errorMessage != null) {
      return Center(child: Text(schoolProvider.errorMessage!));
    }
    if (jobDetails == null || jobDetails['school'] == null) {
      return _textContent("Location details not available");
    }

    final schoolDetails = jobDetails['school'];
    final county = schoolDetails['county']?['name'] ?? "Not Available";
    final subCounty = schoolDetails['sub_county']?['name'] ?? "Not Available";
    final ward = schoolDetails['ward'] ?? "Not Available";
    final formattedAddress =
        schoolDetails['formated_address'] ?? "Not Available";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Where We Are"),
        _locationItem("assets/svg/location.svg", "County: $county"),
        _locationItem("assets/svg/location.svg", "Sub-county: $subCounty"),
        _locationItem("assets/svg/location.svg", "Ward: $ward"),
        _sectionTitle("Location Pin"),
        _locationPin(context, formattedAddress),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFF5F5F5),
          thickness: 1,
        ),
      ],
    );
  }

  Widget _locationItem(String assetPath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SvgPicture.asset(assetPath,
              width: 20, height: 20, color: const Color(0xFF000EF8)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationPin(BuildContext context, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SvgPicture.asset("assets/svg/location_pin.svg",
              width: 20, height: 20, color: const Color(0xFF000EF8)),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _openMaps(context, location),
              child: Text(
                location,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => _openMaps(context, location),
            child: SvgPicture.asset(
              "assets/svg/view_maps.svg",
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMaps(BuildContext context, String location) async {
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}");

    try {
      if (!await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      )) {
        // If launching fails, show an error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open the map'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening map: $e'),
          ),
        );
      }
    }
  }

  Widget _textContent(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF5C5C5C),
          height: 1.5,
        ),
      ),
    );
  }
}
