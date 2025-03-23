import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_teach/gen/assets.gen.dart';

class NotificationTile extends StatefulWidget {
  final String title;
  final String timeAgo;
  final Function(bool) onSelectionChanged;

  const NotificationTile({
    Key? key,
    required this.title,
    required this.timeAgo,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPressed = !isPressed;
          widget.onSelectionChanged(isPressed);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPressed
              ? const Color(0x0D476BE8) // Light blue when selected
              : Colors.white, // Default white background
          border: const Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  Assets
                      .svg.ellipse, // Use the generated asset class for ellipse
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFF5F5FF), // Light purple background
                    BlendMode.srcIn,
                  ),
                ),
                SvgPicture.asset(
                  Assets.svg
                      .jobIcon, // Use the generated asset class for job icon
                  width: 24,
                  height: 24,
                ),
                if (isPressed) // 🔥 Blue dot appears only when clicked
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF476BE8), // Blue dot
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.timeAgo,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFF7D7D7D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
