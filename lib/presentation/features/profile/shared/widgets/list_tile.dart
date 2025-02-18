import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  final String iconPath; // Path to the SVG icon
  final String title;
  final VoidCallback onTap;

  // Static path for the arrow icon
  static const String arrowIconPath =
      'assets/svg/arrow.svg'; // Define the arrow icon path here

  const CustomListTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            iconPath,
            height: 20,
            width: 20,
          ),
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1F1F1F), // Text color
            ),
          ),
          trailing: SvgPicture.asset(
            arrowIconPath, // Static SVG asset for the arrow
            width: 16,
            height: 16,
          ),
          onTap: onTap,
        ),
        Divider(
          color: const Color(0xFFF5F5F5), // Divider color
          thickness: 1, // Divider thickness
        ),
      ],
    );
  }
}
