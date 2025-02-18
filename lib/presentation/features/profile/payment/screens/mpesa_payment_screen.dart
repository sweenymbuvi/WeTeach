import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:we_teach/presentation/features/profile/payment/provider/payment_provider.dart';
import 'package:we_teach/presentation/features/profile/payment/screens/payment_options_screen.dart';
import 'package:we_teach/presentation/features/profile/shared/widgets/action_buttons.dart';

class MpesaPaymentScreen extends StatefulWidget {
  @override
  _MpesaPaymentScreenState createState() => _MpesaPaymentScreenState();
}

class _MpesaPaymentScreenState extends State<MpesaPaymentScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _completePhoneNumber = '';
  String? _paymentMethodId;

  @override
  void initState() {
    super.initState();
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    if (paymentProvider.paymentMethods.isEmpty) {
      paymentProvider.fetchPaymentMethods();
    }
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
                "Mpesa Payment",
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            if (paymentProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final latestPaymentMethod =
                paymentProvider.paymentMethods.isNotEmpty
                    ? paymentProvider.paymentMethods.last
                    : null;

            final paymentMethodId = latestPaymentMethod?['id']?.toString();
            _paymentMethodId = paymentMethodId;

            if (latestPaymentMethod != null && _phoneController.text.isEmpty) {
              _paymentMethodId = latestPaymentMethod['id'].toString();
              String phoneNumber = latestPaymentMethod['phone_number'];

              if (phoneNumber.startsWith('+254')) {
                phoneNumber = phoneNumber.substring(4);
              } else if (phoneNumber.startsWith('254')) {
                phoneNumber = phoneNumber.substring(3);
              }

              _phoneController.text = phoneNumber;
              _completePhoneNumber = latestPaymentMethod['phone_number'];
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Phone Number ",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "712345678",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF828282),
                    ),
                    fillColor: const Color(0xFFFDFDFF),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0x00476be8).withOpacity(0.11),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0x00476be8).withOpacity(0.11),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0x00476be8).withOpacity(0.11),
                      ),
                    ),
                  ),
                  initialCountryCode: 'KE',
                  onChanged: (phone) {
                    setState(() {
                      _completePhoneNumber = phone.completeNumber;
                    });
                  },
                  disableLengthCheck: true,
                ),
                Spacer(),
                ActionButtons(
                  onDiscard: () {
                    Navigator.pop(context);
                  },
                  onSave: () async {
                    if (_completePhoneNumber.isNotEmpty) {
                      if (_paymentMethodId != null) {
                        await paymentProvider.updatePaymentMethod(
                          _paymentMethodId!,
                          _completePhoneNumber,
                          title: "M-Pesa",
                          phoneNumber: _completePhoneNumber,
                        );
                      } else {
                        final newPaymentMethod =
                            await paymentProvider.createPaymentMethod(
                          "M-Pesa",
                          _completePhoneNumber,
                        );

                        if (newPaymentMethod != null &&
                            newPaymentMethod.containsKey('id')) {
                          _paymentMethodId = newPaymentMethod['id'].toString();
                        }
                      }

                      // Navigate to PaymentOptionsScreen with the updated paymentMethodId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentOptionsScreen(
                            paymentMethodId: _paymentMethodId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid phone number."),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
