import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationOptions extends StatelessWidget {
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;

  const NotificationOptions({
    Key? key,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            iconPath: 'assets/svg/envelope_open.svg',
            text: "Mark selected as read",
            onTap: onMarkAsRead,
          ),
          const SizedBox(height: 10),
          _buildOption(
            iconPath: 'assets/svg/envelope_closed.svg',
            text: "Mark selected as unread",
            onTap: onMarkAsUnread,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
