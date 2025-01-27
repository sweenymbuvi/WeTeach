import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon; // Changed to Widget? to support both Icon and SvgPicture
  final bool isOutlined; // Added this parameter

  const ProfileButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    required this.isOutlined, // Make sure it's required
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensures full-width button
      height: 56, // Button height
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(isOutlined
              ? Colors.white
              : Colors.transparent), // Set background color
          side: WidgetStateProperty.all(
            isOutlined
                ? const BorderSide(
                    color: Color(0xFF000EF8), // Border color #000EF8
                    width: 1, // Border width
                  )
                : BorderSide.none, // No border if not outlined
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
            ),
          ),
          foregroundColor:
              WidgetStateProperty.all(Color(0xFF000EF8)), // Text color
          padding: WidgetStateProperty.all(
              EdgeInsets.zero), // Remove padding to make the button flat
          splashFactory: NoSplash.splashFactory, // Disable splash effect
          overlayColor: WidgetStateProperty.all(
              Colors.transparent), // Disable highlight effect
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!, // Use the widget directly
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
