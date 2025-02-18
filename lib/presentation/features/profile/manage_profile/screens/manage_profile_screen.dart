import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/profile/change_password/screens/change_password_screen.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/add_payment_option%20screen.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/payment_options_screen.dart';
import 'package:we_teach/presentation/features/profile/professional_details/screens/professional_details_screen.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/list_tile.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/profile_card.dart';
import 'package:we_teach/presentation/shared/widgets/bottom_nav_bar.dart';

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  int _currentIndex = 4; // Default to 'Profile' as the active screen

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevents default leading widget
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add space from the top
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(width: 8), // Spacing between the arrow and text
              Text(
                "Profile",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false, // Aligns the Row content to the start
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Padding for the body
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const ProfileCard(),
              const SizedBox(
                  height: 24), // Spacing between profile card and settings
              // Settings Section
              Text(
                "Settings",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 8),
              CustomListTile(
                iconPath: 'assets/svg/work_outline.svg',
                title: "Professional Details",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfessionalDetailsScreen()));
                },
              ),
              CustomListTile(
                iconPath: 'assets/svg/task.svg',
                title: "My Jobs",
                onTap: () {},
              ),
              CustomListTile(
                iconPath: 'assets/svg/public.svg',
                title: "Profile Publicity",
                onTap: () {},
              ),
              CustomListTile(
                iconPath: 'assets/svg/history.svg',
                title: "Publicity History",
                onTap: () {},
              ),
              CustomListTile(
                iconPath: 'assets/svg/payment.svg',
                title: "Payments",
                onTap: () async {
                  final paymentProvider =
                      Provider.of<PaymentProvider>(context, listen: false);

                  // Fetch payment methods if not already loaded
                  if (paymentProvider.paymentMethods.isEmpty) {
                    await paymentProvider.fetchPaymentMethods();
                  }

                  if (paymentProvider.paymentMethods.isNotEmpty) {
                    // Get the latest payment method ID
                    final latestPaymentMethod =
                        paymentProvider.paymentMethods.last;
                    final paymentMethodId =
                        latestPaymentMethod['id'].toString();

                    // Navigate to PaymentOptionsScreen with paymentMethodId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentOptionsScreen(
                            paymentMethodId: paymentMethodId),
                      ),
                    );
                  } else {
                    // Navigate to AddPaymentOptionsScreen if no payment method exists
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPaymentOptionsScreen()),
                    );
                  }
                },
              ),
              CustomListTile(
                iconPath: 'assets/svg/password.svg',
                title: "Change Password",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()));
                },
              ),
              const SizedBox(height: 24), // Spacing between sections
              // More Section
              Text(
                "More",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 8),
              CustomListTile(
                iconPath: 'assets/svg/share.svg',
                title: "Share App",
                onTap: () {},
              ),
              CustomListTile(
                iconPath: 'assets/svg/star.svg',
                title: "Rate App",
                onTap: () {},
              ),
              CustomListTile(
                iconPath: 'assets/svg/privacy.svg',
                title: "Terms of Use & Privacy Policy",
                onTap: () {},
              ),
              CustomListTile(
                iconPath: 'assets/svg/logout.svg',
                title: "Log Out",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
