import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDiscard;
  final VoidCallback onSave;
  final bool isLoading; // Optional loading state
  final String saveButtonText; // New parameter for button text

  const ActionButtons({
    Key? key,
    required this.onDiscard,
    required this.onSave,
    this.isLoading = false, // Default to false if not provided
    this.saveButtonText = "Save Changes", // Default text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Space between buttons
      children: [
        // Discard Button
        OutlinedButton(
          onPressed: isLoading ? null : onDiscard, // Disable when loading
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            fixedSize: const Size(120, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFFF5F5F5)),
          ),
          child: Text(
            "Discard",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isLoading
                  ? Colors.grey
                  : const Color(0xFF000EF8), // Grey out when loading
            ),
          ),
        ),

        // Save Changes Button
        ElevatedButton(
          onPressed: isLoading ? null : onSave, // Disable when loading
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            fixedSize: const Size(180, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFF000EF8),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  saveButtonText, // Use the new parameter for button text
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFCFCFC),
                  ),
                ),
        ),
      ],
    );
  }
}
