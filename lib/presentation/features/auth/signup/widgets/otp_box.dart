import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBox extends StatelessWidget {
  const OtpBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0x00476be8)
                  .withOpacity(0.11), // Same color for enabled state
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0x00476be8)
                  .withOpacity(0.11), // Same color for focused state
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  Color(0x00476be8).withOpacity(0.11), // Default border color
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
      ),
    );
  }
}
