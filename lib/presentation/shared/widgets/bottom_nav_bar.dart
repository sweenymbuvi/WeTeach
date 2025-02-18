import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF000EF8), // Highlight selected icon
      unselectedItemColor: const Color(0xFF5C5C5C),
      items: [
        _buildNavBarItem(
          iconPath: 'assets/svg/nav/home.svg',
          label: 'Home',
          index: 0,
        ),
        _buildNavBarItem(
          iconPath: 'assets/svg/nav/bookmark.svg',
          label: 'My Jobs',
          index: 1,
        ),
        _buildApplyIcon(), // Special case for the Apply icon
        _buildNavBarItem(
          iconPath: 'assets/svg/nav/bell.svg',
          label: 'Notifications',
          index: 3,
        ),
        _buildNavBarItem(
          iconPath: 'assets/svg/nav/user.svg',
          label: 'Profile',
          index: 4,
        ),
      ],
      selectedLabelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: const Color(0xFF000EF8),
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: const Color(0xFF5C5C5C),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        height: 24, // Adjust icon size as needed
        width: 24,
        colorFilter: ColorFilter.mode(
          index == currentIndex
              ? const Color(0xFF000EF8) // Selected icon color
              : const Color(0xFF5C5C5C), // Unselected icon color
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildApplyIcon() {
    return BottomNavigationBarItem(
      icon: Padding(
        padding:
            const EdgeInsets.only(top: 8.0), // Adjust for vertical alignment
        child: SvgPicture.asset(
          'assets/svg/apply1.svg',
          height: 40, // Same height as other icons
          width: 40, // Same width as other icons
        ),
      ),
      label: '',
    );
  }
}
