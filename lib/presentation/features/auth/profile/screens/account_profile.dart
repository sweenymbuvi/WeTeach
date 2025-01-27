import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/auth/profile/screens/add_profile_pic.dart';
import 'package:we_teach/presentation/features/auth/welcome/widgets/my_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  String? selectedLevel;
  final List<String> institutionLevels = [
    'Primary School',
    'Secondary School',
    'University',
  ];
  final int _currentPage = 0;
  final Color borderColor = Color(0x00476be8).withOpacity(0.11);

  Widget buildSectionTitle(String title) {
    return Material(
      color: const Color(0xFFFDFDFF), // Set background color to #FDFDFF
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black, // Changed to black
              ),
            ),
            Text(
              '*',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    Widget? prefixIcon,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black, // Change color to black when typing
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF828282),
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: prefixIcon,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFFDFDFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.04);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            snap: true,
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
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      width: screenWidth * 0.025,
                      height: screenWidth * 0.025,
                      decoration: BoxDecoration(
                        color: _currentPage == index
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Let\'s get to know you',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      buildSectionTitle('Full Name'),
                      SizedBox(height: screenHeight * 0.02),
                      buildTextField(
                        hintText: 'Enter name',
                        prefixIcon: SvgPicture.asset(
                          'assets/svg/user.svg',
                          height: screenWidth * 0.06,
                          width: screenWidth * 0.06,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Phone Number'),
                      SizedBox(height: screenHeight * 0.02),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText:
                              '712345678', // Use hintText instead of labelText
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                                0xFF333333), // Set hint text color to #333333
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFDFDFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                        ),
                        initialCountryCode: 'KE',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                        disableLengthCheck: true,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Profile Description'),
                      SizedBox(height: screenHeight * 0.02),
                      buildTextField(
                        hintText: 'Tell others about yourself',
                        maxLines: 5,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Teaching Experience'),
                      SizedBox(height: screenHeight * 0.02),
                      buildTextField(hintText: 'Enter number of years'),
                      SizedBox(height: screenHeight * 0.02),
                      buildSectionTitle('Institution Level'),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        value: selectedLevel,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLevel = newValue;
                          });
                        },
                        items: institutionLevels
                            .map((level) => DropdownMenuItem<String>(
                                  value: level,
                                  child:
                                      Text(level, style: GoogleFonts.inter()),
                                ))
                            .toList(),
                        hint: Text(
                          'Select institution level',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF828282),
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/svg/school.svg',
                              height: screenWidth * 0.06,
                              width: screenWidth * 0.06,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFDFDFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: Column(
                          children: [
                            CustomButton(
                              text: "Continue",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddProfilePhotoScreen()));
                              },
                            ),
                            SizedBox(
                                height:
                                    screenHeight * 0.02), // Added white space
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
