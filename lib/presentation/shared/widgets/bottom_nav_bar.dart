import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/home/home_screen/screens/home_screen.dart';
import 'package:we_teach/presentation/features/live_profile/screens/teacher_profile_screen.dart';
import 'package:we_teach/presentation/features/my_jobs/screens/my_jobs_screen.dart';
import 'package:we_teach/presentation/features/profile/manage_profile/screens/manage_profile_screen.dart';
import 'package:we_teach/presentation/features/publicity_history/screens/publicity_history_screen.dart';

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
      onTap: (index) {
        // Handle navigation based on the tapped index
        if (index == currentIndex) {
          // If the tapped index is the same as the current index, do nothing
          return;
        }

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            // Do nothing, already on My Jobs screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyJobsScreen()),
            );
            break;
          case 2:
            // Handle Apply icon tap (implement this action)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PublicityHistoryScreen()),
            );
            break;
          case 3:
            // Navigate to Notifications screen (implement this screen)
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ManageProfileScreen()),
            );
            break;
        }
        onTap(index); // Call the provided onTap function
      },
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
