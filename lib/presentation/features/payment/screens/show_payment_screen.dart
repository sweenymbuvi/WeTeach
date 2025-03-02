import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/jobs/screens/job_details_screen.dart';
import 'package:we_teach/presentation/features/payment/provider/job_payment_provider.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/services/secure_storage_service.dart';

class PaymentBottomSheet {
  static void show(BuildContext context, {required int jobId}) {
    TextEditingController _phoneController = TextEditingController();
    String _completePhoneNumber = '';
    ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

    final paymentProvider =
        Provider.of<JobPaymentProvider>(context, listen: false);

    // Fetch user details when the bottom sheet is shown
    paymentProvider.fetchUserDetails();

    paymentProvider.fetchPaymentMethods().then((_) {
      if (paymentProvider.paymentMethods.isNotEmpty) {
        final latestPaymentMethod = paymentProvider.paymentMethods.last;
        String phoneNumber = latestPaymentMethod['phone_number'];

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
      isScrollControlled: true, // This ensures the bottom sheet can resize
      builder: (context) {
        return Padding(
          // Add padding to account for keyboard
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                16.0, // Add padding for keyboard
          ),
          child: SingleChildScrollView(
            // Wrap in SingleChildScrollView for scrolling
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
                  "A small fee is paid to view a job post or explore an institution",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    debugPrint("Selected Job ID for Mpesa: $jobId");
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
                    return CustomButton(
                      text: "Proceed to Pay",
                      onPressed: isEnabled
                          ? () {
                              Navigator.pop(context);

                              String formattedPhoneNumber =
                                  _completePhoneNumber.isNotEmpty
                                      ? _completePhoneNumber.replaceAll('+', '')
                                      : _phoneController.text;

                              paymentProvider.makePayment(
                                phoneNumber: formattedPhoneNumber,
                                jobId: jobId,
                              );

                              showProcessingPaymentBottomSheet(context,
                                  formattedPhoneNumber, paymentProvider, jobId);
                            }
                          : null, // Disable button if not enabled
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

  static void showProcessingPaymentBottomSheet(BuildContext context,
      String phoneNumber, JobPaymentProvider paymentProvider, int jobId) {
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
            final paymentId = paymentProvider.paymentResponse?['payment']['id'];

            if (paymentId != null) {
              // Get the access token
              final accessToken = await SecureStorageService().getAccessToken();

              if (accessToken != null) {
                // Check payment status
                await paymentProvider.checkPaymentStatus(
                  accessToken: accessToken,
                  paymentId: paymentId,
                );

                // If payment is successful, navigate to success screen
                if (paymentProvider.paymentStatus == "Paid" ||
                    paymentProvider.paymentStatus == "Payment Successful ✅") {
                  timer.cancel();
                  if (isBottomSheetActive) {
                    isBottomSheetActive = false;
                    Navigator.pop(context);
                    PaymentBottomSheet.showPaymentSuccessBottomSheet(
                        context, jobId);
                  }
                }
              }
            }

            // Set a timeout after 3 minutes (36 checks at 5-second intervals)
            if (timer.tick >= 5) {
              timer.cancel();
              if (isBottomSheetActive) {
                isBottomSheetActive = false;
                Navigator.pop(context);
                show(context, jobId: jobId);
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
                  onTap: () {
                    // Resend payment prompt
                    paymentProvider.makePayment(
                      phoneNumber: phoneNumber,
                      jobId: jobId,
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

  static void showPaymentSuccessBottomSheet(BuildContext context, int jobId) {
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
                'assets/images/success.gif',
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
                "You can now view all details about the job posting you have selected.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "View Job Details",
                onPressed: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JobDetailsScreen(jobId: jobId), // Pass jobId
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
