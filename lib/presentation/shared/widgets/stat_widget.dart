import 'package:flutter/material.dart';

class StatWidget extends StatelessWidget {
  final Widget iconPath;
  final String value;
  final String label;

  const StatWidget({
    required this.iconPath,
    required this.value,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SizedBox(
              height: 24.0,
              width: 24.0,
              child: iconPath, // Icon placed inside the circle
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stat value with font color #333333 and Inter font
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 2),

              Text(
                label,
                style: const TextStyle(
                  fontSize: 7,
                  color: Color(0xFF333333),
                  fontFamily: 'Inter',
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
