import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordField extends StatelessWidget {
  final String hintText;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;
  final Color fillColor;
  final Color borderColor;

  const PasswordField({
    super.key,
    required this.hintText,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF828282), // Customize hint color and style
        ),
        filled: true,
        fillColor: fillColor, // Background color for the text field
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            'assets/svg/lock.svg',
            height: 20, // Adjusted lock icon size
            width: 20,
            fit: BoxFit.scaleDown,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
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
}
