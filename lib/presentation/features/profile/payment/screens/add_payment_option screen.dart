import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/card_payment_screen.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/mpesa_payment_screen.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/payment_card.dart';

class AddPaymentOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(width: 8),
              Text(
                "Payment Options",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10),
            child: SvgPicture.asset(
              'assets/svg/add.svg', // Replace with your actual SVG asset path
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select option to add or edit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000EF8), // Updated color
              ),
            ),
            SizedBox(height: 16),
            PaymentOptionCard(
              logo:
                  'assets/images/mpesa.png', // Replace with your M-Pesa logo path
              title: 'Mpesa',
              subtitle: 'Edit your Mpesa number',
              onTap: () {
                // Logic for editing M-Pesa
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MpesaPaymentScreen()));
              },
              onMoreOptions: () {},
              onEditPressed: () {},
            ),
            SizedBox(height: 16),
            PaymentOptionCard(
              logo:
                  'assets/images/visa.png', // Replace with your Visa/Mastercard logo path
              title: 'Bank Card',
              subtitle: 'Add your bank card to pay from bank account',
              onTap: () {
                // Logic for adding a bank card
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CardPaymentScreen()));
              },
              onMoreOptions: () {},
              onEditPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
