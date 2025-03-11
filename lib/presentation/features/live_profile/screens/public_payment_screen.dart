import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';
import 'package:we_teach/presentation/features/live_profile/screens/public_profile_payment_screen.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

void showPublicityPackageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return const PublicityPackageBottomSheet();
    },
  );
}

class PublicityPackageBottomSheet extends StatefulWidget {
  const PublicityPackageBottomSheet({Key? key}) : super(key: key);

  @override
  _PublicityPackageBottomSheetState createState() =>
      _PublicityPackageBottomSheetState();
}

class _PublicityPackageBottomSheetState
    extends State<PublicityPackageBottomSheet> {
  int selectedPackageIndex = 2;

  final List<Map<String, dynamic>> packages = [
    {"days": 1, "price": 200},
    {"days": 3, "price": 600},
    {"days": 5, "price": 800},
    {"days": 7, "price": 1200},
    {"days": 14, "price": 2000},
  ];

  @override
  void initState() {
    super.initState();
    // Fetch user data when the bottom sheet is opened
    Future.microtask(() {
      Provider.of<ProfileDetailsProvider>(context, listen: false)
          .fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailsProvider>(
      builder: (context, profileProvider, child) {
        final isLoading = profileProvider.isLoading;
        final errorMessage = profileProvider.errorMessage;
        final userData = profileProvider.userData;

        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar at the top
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title & Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select a Publicity Package",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  // Error message (if any)
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Loading indicator while fetching user data
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (userData == null)
                    const Center(
                      child: Text("Failed to load user data."),
                    )
                  else ...[
                    // Package selection
                    Expanded(
                      child: ListView.builder(
                        itemCount: packages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final package = packages[index];
                          final isSelected = selectedPackageIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPackageIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0x1C476BE8)
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF000EF8)
                                      : const Color(0xFFF5F5F5),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${package['days']} Days for Ksh ${package['price']}",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF828282),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Pay Ksh ${package['price']} to keep your profile live for ${package['days']} days",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF5C5C5C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Radio<int>(
                                    value: index,
                                    groupValue: selectedPackageIndex,
                                    activeColor: const Color(0xFF000EF8),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPackageIndex = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Pay Button
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      child: CustomButton(
                        text: "Pay for Package",
                        onPressed: () async {
                          final teacherId = userData['teacher_id'];
                          if (teacherId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to get teacher ID."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Post teacher profile before proceeding
                          await profileProvider.postTeacherProfile();

                          // Proceed to payment after successful profile creation
                          Navigator.pop(context);
                          final selectedPackage =
                              packages[selectedPackageIndex];
                          ProfilePublicityPaymentSheet.show(
                            context,
                            profileId: teacherId,
                            selectedPackage: selectedPackage,
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
