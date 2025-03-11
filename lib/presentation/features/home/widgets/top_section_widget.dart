import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/home/home_screen/provider/user_details_provider.dart';
import 'package:we_teach/presentation/features/home/widgets/profile_status_card.dart';
import 'package:we_teach/presentation/features/search/screens/job_search_screen.dart';

class TopSection extends StatelessWidget {
  final bool showProfileStatus; // Add a flag to show/hide ProfileStatusCard

  const TopSection({
    Key? key,
    this.showProfileStatus = true, // Default to true, so it shows by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);

    return Stack(
      children: [
        Container(
          height: 140,
          color: const Color(0xFFF5F6FF),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message & Profile Picture
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            userDetailsProvider.userData?['image'] != null
                                ? NetworkImage(
                                    userDetailsProvider.userData!['image'])
                                : const AssetImage("assets/images/man.png")
                                    as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome 👋",
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF7D7D7D),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            userDetailsProvider.userData?['full_name'] ??
                                'Unknown User',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/svg/live.svg',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobSearchScreen()),
                  );
                },
                child: AbsorbPointer(
                  // Prevents keyboard from opening in the current screen
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for jobs",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF828282),
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/svg/lens.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/rectangle.svg',
                              width: 56,
                              height: 40,
                            ),
                            SvgPicture.asset(
                              'assets/svg/filter.svg',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFBDBDBD),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFBDBDBD),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFBDBDBD),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Conditionally show Profile Status Card
            if (showProfileStatus)
              ProfileStatusCard(
                //isProfileLive: false, // Set this based on your logic
                parentContext: context, // Pass the parent context here
              ),
          ],
        ),
      ],
    );
  }
}
