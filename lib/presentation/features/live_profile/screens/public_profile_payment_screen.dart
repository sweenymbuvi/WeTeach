import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/gen/assets.gen.dart';
import 'package:we_teach/presentation/features/live_profile/provider/live_profile_provider.dart';
import 'package:we_teach/presentation/features/live_profile/provider/profile_details_provider.dart';
import 'package:we_teach/presentation/features/live_profile/screens/teacher_profile_screen.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/action_buttons.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ProfilePublicityPaymentSheet {
  static void show(
    BuildContext context, {
    required int profileId,
    Map<String, dynamic>? selectedPackage,
  }) {
    TextEditingController _phoneController = TextEditingController();
    String _completePhoneNumber = '';
    ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

    // Default to 0 if no package is provided or price is missing
    final int packagePrice =
        selectedPackage != null ? (selectedPackage['price'] as int) : 0;
    final int packageDays =
        selectedPackage != null ? (selectedPackage['days'] as int) : 0;

    // Get the provider
    final paymentProvider =
        Provider.of<LiveProfileProvider>(context, listen: false);

    // Fetch payment methods when the bottom sheet is shown
    paymentProvider.fetchPaymentMethods().then((_) {
      if (paymentProvider.paymentMethods.isNotEmpty) {
        final latestPaymentMethod = paymentProvider.paymentMethods.last;
        String phoneNumber = latestPaymentMethod['phone_number'];

        // Format the phone number
        if (phoneNumber.startsWith('+254')) {
          phoneNumber = phoneNumber.substring(4);
        } else if (phoneNumber.startsWith('254')) {
          phoneNumber = phoneNumber.substring(3);
        }

        _phoneController.text = phoneNumber;
        _completePhoneNumber = latestPaymentMethod['phone_number'];
        isButtonEnabled.value = phoneNumber.length >= 9; // Enable if valid
      }
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Select payment option",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "A small fee of Ksh $packagePrice is paid to make your profile public for $packageDays days",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    debugPrint("Selected Profile ID for Mpesa: $profileId");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000EF8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Mpesa",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "712345678",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                    ),
                    fillColor: const Color(0xFFFDFDFF),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  initialCountryCode: 'KE',
                  onChanged: (phone) {
                    _completePhoneNumber = phone.completeNumber;
                    isButtonEnabled.value = phone.number.length >= 9;
                  },
                  disableLengthCheck: true,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return ActionButtons(
                      onDiscard: () {
                        Navigator.pop(context); // Close the modal on discard
                      },
                      onSave: () {
                        if (isEnabled) {
                          Navigator.pop(context);
                          String formattedPhoneNumber =
                              _completePhoneNumber.isNotEmpty
                                  ? _completePhoneNumber.replaceAll('+', '')
                                  : _phoneController.text;

                          // Check if the phone number is valid
                          if (formattedPhoneNumber.length >= 9) {
                            // Call the makeProfileLive method from ProfileDetailsProvider
                            final profileDetailsProvider =
                                Provider.of<ProfileDetailsProvider>(context,
                                    listen: false);
                            profileDetailsProvider.makeProfileLive(
                              phoneNumber: formattedPhoneNumber,
                            );

                            showProcessingPaymentBottomSheet(
                                context,
                                formattedPhoneNumber,
                                profileId,
                                packageDays,
                                profileDetailsProvider);
                          } else {
                            // Show an error message if the phone number is invalid
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Please enter a valid phone number."),
                              ),
                            );
                          }
                        }
                      },
                      isLoading: false, // Set loading state if needed
                      saveButtonText:
                          "Proceed to Pay", // Set the button text here
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showProcessingPaymentBottomSheet(
      BuildContext context,
      String phoneNumber,
      int profileId,
      int packageDays,
      ProfileDetailsProvider profileDetailsProvider) {
    // Flag to track if the bottom sheet is still active
    bool isBottomSheetActive = true;

    // Timer for polling payment status
    Timer? statusCheckTimer;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: false,
      builder: (context) {
        // Start polling for payment status
        statusCheckTimer = Timer.periodic(
          const Duration(seconds: 5), // Check every 5 seconds
          (timer) async {
            // Get the latest payment ID from provider
            final paymentId =
                profileDetailsProvider.paymentId; // Use the public getter

            if (paymentId != null) {
              // Check payment status
              await profileDetailsProvider.checkPaymentStatus(
                  paymentId: paymentId);

              // If payment is successful, navigate to success screen
              if (profileDetailsProvider.paymentStatus == "Paid" ||
                  profileDetailsProvider.paymentStatus ==
                      "Payment Successful ✅") {
                timer.cancel();
                if (isBottomSheetActive) {
                  isBottomSheetActive = false;
                  Navigator.pop(context);
                  showPaymentSuccessBottomSheet(
                      context, profileId, packageDays);
                }
              }
            }

            // Set a timeout after 3 minutes (36 checks at 5-second intervals)
            if (timer.tick >= 36) {
              timer.cancel();
              if (isBottomSheetActive) {
                isBottomSheetActive = false;
                Navigator.pop(context);
                // Optionally show a timeout message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Payment check timed out.")),
                );
              }
            }
          },
        );

        return WillPopScope(
          onWillPop: () async => false, // Prevent back button from dismissing
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Image.asset(
                  'assets/images/loading.gif',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Text(
                  "Processing payment",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "An Mpesa prompt was sent to $phoneNumber.\nKindly enter your PIN to complete payment",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    // Format the phone number correctly
                    String formattedPhoneNumber = phoneNumber.isNotEmpty
                        ? phoneNumber.replaceAll('+', '')
                        : '';

                    // Get the ProfileDetailsProvider
                    final profileDetailsProvider =
                        Provider.of<ProfileDetailsProvider>(context,
                            listen: false);

                    // Re-trigger the payment request without reopening the bottom sheet
                    await profileDetailsProvider.makeProfileLive(
                        phoneNumber: formattedPhoneNumber);

                    // Show a message to indicate the new request was sent
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "New Mpesa prompt sent to $formattedPhoneNumber")),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't get prompt? ",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5C5C5C),
                      ),
                      children: [
                        TextSpan(
                          text: "Request prompt",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000EF8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Clean up when bottom sheet is closed
      statusCheckTimer?.cancel();
      isBottomSheetActive = false;
    });
  }

  static void showPaymentSuccessBottomSheet(
      BuildContext context, int profileId, int packageDays) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Image.asset(
                Assets.images.success.path, // Use the generated asset class
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              Text(
                "Payment Successful",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your transaction was successful. Your profile is now live for schools to see. View your impressions on the statistics page",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Got It", // Pass the text here
                onPressed: () {
                  Navigator.pop(context); // Close bottom sheet
                  // Navigate to the live profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TeacherLiveProfileScreen(), // Ensure this is the correct screen
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
