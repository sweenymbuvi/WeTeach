import 'package:flutter/material.dart';
import 'package:we_teach/presentation/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? Colors.grey
              : AppTheme.primaryColor, // Disable button when onPressed is null
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400, // Set font weight to 400
            color: onPressed == null
                ? Colors.grey[500]
                : Color(0xFFFCFCFC), // Set text color to #FCFCFC
          ),
        ),
      ),
    );
  }
}
