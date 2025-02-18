import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/add_payment_option%20screen.dart';

class PaymentOptionCard extends StatelessWidget {
  final String logo;
  final String title;
  final String subtitle;
  final String? paymentMethodId; // Added for delete logic
  final VoidCallback onTap;
  final VoidCallback onMoreOptions; // Callback for more options
  final bool showThreeDots;
  final VoidCallback onEditPressed; // New callback for edit action

  const PaymentOptionCard({
    required this.logo,
    required this.title,
    required this.subtitle,
    this.paymentMethodId, // Added for delete logic
    required this.onTap,
    required this.onMoreOptions,
    required this.onEditPressed, // Add this parameter
    this.showThreeDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFEBEBEB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Stack to hold the large rectangle image and the smaller image
            Stack(
              alignment: Alignment.center,
              children: [
                // Rectangle image (96x56)
                Image.asset(
                  'assets/images/rectangle.png', // Replace with your rectangle image path
                  width: 96,
                  height: 56,
                  fit: BoxFit.cover,
                ),
                // Smaller image (80x40) on top
                Image.asset(
                  logo, // This will be the smaller image path
                  width: 80,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(width: 16),
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title text and three dots in the same row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title text
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      // Conditionally render the SVG asset of three dots based on `showThreeDots`
                      if (showThreeDots)
                        GestureDetector(
                          onTap: () {
                            // Show the options popup when the three dots are tapped
                            _showOptions(context);
                          },
                          child: SvgPicture.asset(
                            'assets/svg/dots.svg', // Replace with your SVG asset path
                            width: 16,
                            height: 16,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Subtitle text
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: Color(0xFF5C5C5C),
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

  // Method to show the options pop-up with Edit and Delete options
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit option
              ListTile(
                leading: SvgPicture.asset(
                  'assets/svg/edit_option.svg',
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'Edit Option',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: Color(0xFF333333),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet first
                  Future.delayed(Duration(milliseconds: 200), onEditPressed);
                },
              ),
              // Delete option
              ListTile(
                leading: SvgPicture.asset(
                  'assets/svg/delete.svg',
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: Color(0xFF333333),
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet

                  if (paymentMethodId != null) {
                    final provider =
                        Provider.of<PaymentProvider>(context, listen: false);

                    // Store a reference to the current context before async operation
                    final navigator = Navigator.of(context);

                    await provider.deletePaymentMethod(paymentMethodId!);

                    // Show success message
                    ScaffoldMessenger.of(navigator.context).showSnackBar(
                      SnackBar(
                        content: Text("Payment method deleted successfully"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Navigate back to AddPaymentOptionsScreen
                    navigator.pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => AddPaymentOptionsScreen()),
                    );
                  } else {
                    print("Error: No paymentMethodId provided for deletion.");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
