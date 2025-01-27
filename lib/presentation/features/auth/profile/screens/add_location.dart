import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/finished_profile.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  String? selectedCounty;
  String? selectedSubCounty;

  final List<String> counties = ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru'];
  final Map<String, List<String>> subCounties = {
    'Nairobi': ['Westlands', 'Langata', 'Kasarani', 'Embakasi'],
    'Mombasa': ['Kisauni', 'Likoni', 'Nyali', 'Changamwe'],
    'Kisumu': ['Kisumu West', 'Kisumu East', 'Nyando', 'Muhoroni'],
    'Nakuru': ['Naivasha', 'Njoro', 'Nakuru East', 'Rongai'],
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int currentPage = 3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: screenWidth * 0.04,
              top: screenHeight * 0.02,
            ),
            child: Row(
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  width: screenWidth * 0.025,
                  height: screenWidth * 0.025,
                  decoration: BoxDecoration(
                    color: index <= currentPage
                        ? const Color(0xFFAC00E6)
                        : const Color(0xFFF0F0F0),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
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
              items: counties
                  .map((county) =>
                      DropdownMenuItem(value: county, child: Text(county)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCounty = value;
                  selectedSubCounty = null;
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
              items: selectedCounty != null
                  ? subCounties[selectedCounty]!
                      .map((subCounty) => DropdownMenuItem(
                          value: subCounty, child: Text(subCounty)))
                      .toList()
                  : [],
              onChanged: (value) {
                setState(() {
                  selectedSubCounty = value;
                });
              },
            ),
            Spacer(),
            CustomButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCompleteScreen()));
                }),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
