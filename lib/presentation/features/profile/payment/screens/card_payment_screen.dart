import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/action_buttons.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/text_field.dart';

class CardPaymentScreen extends StatefulWidget {
  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController.text = '2222 4444 6666 8888'; // Default value
  }

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
                "Card Payment",
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
              'assets/svg/edit.svg',
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            CustomTextField(
              label: "Account Number",
              controller: _cardNumberController,
              isRequired: false,
              assetImage: 'assets/images/logos_mastercard.png',
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      label: "Expiry",
                      initialValue: '08/28',
                      isRequired: false),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                      label: "CCV", initialValue: '123', isRequired: false),
                ),
              ],
            ),
            Divider(color: Color(0xFFF5F5F5), thickness: 1),
            SizedBox(height: 16),
            CustomTextField(
                label: "Customer Name",
                initialValue: "Enter card holder's name",
                isRequired: false),
            Spacer(),
            ActionButtons(
              onDiscard: () => Navigator.of(context).pop(),
              onSave: () {
                Navigator.pop(
                    context, _cardNumberController.text); // Return card number
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
