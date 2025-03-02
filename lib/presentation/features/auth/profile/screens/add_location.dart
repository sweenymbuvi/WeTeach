import 'dart:async'; // Import this for Future
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import this for Provider
import 'package:we_teach/data/repositories/auth/auth_repo.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/finished_profile.dart';
import 'package:we_teach/presentation/features/auth/signup/provider/auth_provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/services/secure_storage_service.dart'; // Import SecureStorageService

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  String? selectedCounty;
  String? selectedSubCounty;
  Map<String, String> counties = {}; // Use a map to store county names and IDs
  Map<String, String> subCountyIds =
      {}; // Map to store sub-county names and IDs

  @override
  void initState() {
    super.initState();
    // Store the last visited screen
    SecureStorageService().storeLastVisitedScreen('AddLocationScreen');
    _loadCounties(); // Load counties when the widget is initialized
  }

  Future<void> _loadCounties() async {
    try {
      // Get the AuthProvider instance
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Ensure tokens are loaded
      await authProvider.loadTokens();
      // Get the access token using the getter
      final accessToken = authProvider.accessToken;

      if (accessToken != null) {
        List<Map<String, String>> fetchedCounties =
            await AuthRepository.fetchCounties(accessToken);
        setState(() {
          counties = Map.fromIterable(
            fetchedCounties,
            key: (county) => county['name'], // Use county name as the key
            value: (county) => county['id'], // Use county ID as the value
          );
        });
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print("Error fetching counties: $e");
    }
  }

  Future<void> _loadSubCounties(String countyId) async {
    try {
      // Get the AuthProvider instance
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Ensure tokens are loaded
      await authProvider.loadTokens();
      // Get the access token using the getter
      final accessToken = authProvider.accessToken;

      if (accessToken != null) {
        List<Map<String, String>> fetchedSubCounties =
            await AuthRepository.fetchSubCounties(countyId, accessToken);
        setState(() {
          subCountyIds = Map.fromIterable(
            fetchedSubCounties,
            key: (subCounty) =>
                subCounty['name'], // Use sub-county name as the key
            value: (subCounty) =>
                subCounty['id'], // Use sub-county ID as the value
          );
        });
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print("Error fetching sub-counties: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthProvider>(context); // Access the auth provider

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Add your Location",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                text: "County of Residence ",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1F1F1F),
                ),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: SvgPicture.asset(
                  'assets/svg/location.svg',
                  height: 5,
                  width: 5,
                  fit: BoxFit.scaleDown,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0x00476be8).withOpacity(0.11),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0x00476be8).withOpacity(0.11),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0x00476be8).withOpacity(0.11),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintText: "Select county",
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF828282),
                ),
              ),
              value: selectedCounty,
              items: counties.keys
                  .map((county) =>
                      DropdownMenuItem(value: county, child: Text(county)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCounty = value;
                  selectedSubCounty = null; // Reset sub-county selection
                  if (value != null) {
                    // Load sub-counties when a county is selected
                    String countyId = counties[value]!; // Get the county ID
                    _loadSubCounties(countyId); // Pass the county ID
                  }
                });
              },
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                text: "Sub-county ",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1F1F1F),
                ),
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: SvgPicture.asset(
                  'assets/svg/location.svg',
                  height: 5,
                  width: 5,
                  fit: BoxFit.scaleDown,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0x00476be8).withOpacity(0.11),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0x00476be8).withOpacity(0.11),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0x00476be8).withOpacity(0.11),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintText: "Select sub-county",
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF828282),
                ),
              ),
              value: selectedSubCounty,
              items: subCountyIds.keys // Use the map of sub-county IDs
                  .map((subCounty) => DropdownMenuItem(
                      value: subCounty, child: Text(subCounty)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubCounty = value;
                });
              },
            ),
            Spacer(),
            CustomButton(
              text: 'Continue',
              onPressed: () async {
                if (selectedCounty != null && selectedSubCounty != null) {
                  // Get the IDs of the selected county and sub-county
                  String countyId =
                      counties[selectedCounty]!; // This is a String
                  String subCountyId =
                      subCountyIds[selectedSubCounty]!; // Get the sub-county ID

                  // Convert countyId and subCountyId to integers
                  int countyIdInt = int.parse(countyId); // Convert to int
                  int subCountyIdInt = int.parse(subCountyId); // Convert to int

                  // Retrieve user ID from secure storage
                  final secureStorageService = SecureStorageService();
                  final userId = await secureStorageService.getUserId();

                  // Check if userId is null
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("User  ID not found. Please log in again."),
                      ),
                    );
                    return;
                  }

                  // Call the updateTeacherProfile method
                  final success = await Provider.of<AuthProvider>(context,
                          listen: false)
                      .updateTeacherProfile(
                          userId: userId, // Pass the user ID
                          county: countyIdInt, // Pass the county ID
                          subCounty: subCountyIdInt // Pass the sub-county ID
                          );

                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileCompleteScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Failed to update county and sub-county."),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Please select both county and sub-county."),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
