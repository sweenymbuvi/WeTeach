import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller; // Make controller optional
  final String? initialValue; // Add an optional initial value
  final bool isRequired; // Add this optional parameter
  final String? assetImage; // Optional parameter for asset image

  const CustomTextField({
    Key? key,
    required this.label,
    this.controller, // Update to optional controller
    this.initialValue, // Add initial value
    this.isRequired = true, // Default is true (shows the red star)
    this.assetImage, // Asset image is optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the border color
    final borderColor =
        Color(0xFFBDBDBD); // You can change this to any color you want

    // If controller is not provided, create a TextEditingController with the initial value
    final effectiveController =
        controller ?? TextEditingController(text: initialValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and optional Star
          Row(
            children: [
              Text(
                "$label",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter', // Updated to use the Inter font
                  color: Color(0xFF1F1F1F),
                ),
              ),
              if (isRequired) // Only show the red star if isRequired is true
                Text(
                  " *",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter', // Updated to use the Inter font
                    color: Colors.red, // Red for the star
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          // TextField
          TextField(
            controller: effectiveController, // Use the effective controller
            decoration: InputDecoration(
              hintText: "Enter $label",
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter', // Updated to use the Inter font
                color: Color(0xFF333333),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: borderColor, width: 1), // Set border width to 1px
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: borderColor, width: 1), // Set border width to 1px
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: borderColor, width: 1), // Set border width to 1px
              ),
              filled: true,
              fillColor: Color(0xFFFDFDFF), // Retained fill color
              suffixIcon: assetImage != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        assetImage!,
                        height: 20, // Adjust height as needed
                        width: 20, // Adjust width as needed
                      ),
                    )
                  : null, // Only display if assetImage is provided
            ),
          ),
        ],
      ),
    );
  }
}
